import React, { Component } from 'react';

import Conversation from './Conversation';

import { createMessage, updateActivity } from '@/actions/chat';
import createChannel from '@/utils/cable';

class Chat extends Component {
  constructor(props) {
    super(props);

    this.charsCount = 0;

    this.state = {
      isRoomDeleted: props.data.room_deleted,
      messages: props.data.messages,
      currentUserId: props.data.current_user_id,
      currentMessage: '',
      typers: [],
    };

    this.appSubscription = createChannel(
      {
        channel: 'AppChannel',
      },
      {
        received: this.handleChannelResponse,
      },
    );

    this.userSubscription = createChannel(
      {
        channel: 'UserChannel',
      },
      {
        received: this.handleChannelResponse,
      },
    );

    this.roomSubscription = createChannel(
      {
        channel: 'RoomChannel',
        room_id: props.data.room_id,
      },
      {
        received: (response) => {
          if (response.message === 'typing') {
            this.handleTypingAction(response);
          }
        },
        userTyping: (typing) => {
          this.roomSubscription.perform('user_typing', { typing, room_id: props.data.room_id });
        },
      },
    );

    window.onbeforeunload = () => {
      updateActivity(props.data.room_id);
    };
  }

  handleChannelResponse = (response) => {
    switch (response.type) {
      case 'room_message_create':
        this.handleNewMessage(response.data);
        break;
      case 'room_message_update':
      case 'room_message_destroy':
        this.handleUpdatedMessage(response.data);
        break;
      default:
        throw new Error(`Unknown response type: ${response.type}`);
    }
  }

  handleClosedRoom = () => {
    this.setState({ isRoomDeleted: true });
  }

  handleMessageChange = (e) => {
    this.setState({ currentMessage: e.target.value });
  }

  handleNewMessage = (data) => {
    const messages = [...this.state.messages, data];
    this.setState({ messages });
  }

  handleUpdatedMessage = (data) => {
    const messages = [...this.state.messages];
    const index = _.findIndex(messages, { id: data.id });

    messages.splice(index, 1, data);
    this.setState({ messages });
  }

  handleTypingAction = (data) => {
    const typers = _.uniqBy([data.user, ...this.state.typers], 'id');

    if (!data.typing || data.user.id === this.state.currentUserId) {
      const index = typers.indexOf(data.user);
      typers.splice(index, 1);
    }

    this.setState({ typers });
  }

  handleUserTyping = (e) => {
    const currentCharsCount = e.target.value.length;
    const typingStatusChanged = Boolean(currentCharsCount) !== Boolean(this.charsCount);

    if (typingStatusChanged) {
      this.setState({ currentMessage: e.target.value });
      this.roomSubscription.userTyping(e.target.value !== '');
    }
    this.charsCount = currentCharsCount;
  }

  handleMessageSubmit = (e) => {
    e.preventDefault();

    if (this.state.currentMessage !== '') {
      const params = {
        room_id: this.props.data.room_id,
        body: this.state.currentMessage,
      };

      createMessage(params, () => {
        this.setState({ currentMessage: '' });
        this.roomSubscription.userTyping(false);
      });
    }
  }

  render() {
    const {
      isRoomDeleted,
      messages,
      currentUserId,
      currentMessage,
      typers,
    } = this.state;

    return (
      <div className="chat">
        <Conversation
          currentUserId={currentUserId}
          messages={messages}
          typers={typers}
        />

        {isRoomDeleted ? (
          <p className="chat__info">Room was closed by owner</p>
        ) : (
          <form onSubmit={this.handleMessageSubmit} className="message-area">
            <div className="input-group">
              <input
                value={currentMessage}
                onChange={this.handleMessageChange}
                onKeyUp={this.handleUserTyping}
                className="form-control"
              />
              <div className="input-group-append">
                <button type="submit" className="btn btn-primary">Send</button>
              </div>
            </div>
          </form>
        )}
      </div>
    );
  }
}

export default Chat;
