import React, { Component } from 'react';
import PropTypes from 'prop-types';

import Conversation from './Conversation';
import MessageForm from './MessageForm';

import { loadMessages, updateActivity } from '@/actions/chat';
import createChannel from '@/utils/cable';

class Chat extends Component {
  messagesLimit = 20

  constructor(props) {
    super(props);

    this.state = {
      isAccessible: props.data.is_accessible,
      messages: props.data.messages,
      currentUserId: props.data.current_user_id,
      loadMoreVisible: props.data.messages.length === this.messagesLimit,
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
      case 'room_open':
      case 'room_close':
        this.handleRoomAccess(response.data);
        break;
      default:
        break;
    }
  }

  handleMessagesLoading = () => {
    const scrollableContainer = document.querySelector('.chat__conversation');
    const chatMessagesElement = document.querySelector('.chat__messages');
    const chatMessagesHeightBefore = chatMessagesElement.offsetHeight;

    const params = {
      roomId: this.props.data.room_id,
      lastId: this.state.messages[0].id,
      limit: this.messagesLimit,
    };

    loadMessages(params)
      .then(response => response.json())
      .then(data => this.setState(prevState => ({
        messages: [...data, ...prevState.messages],
        loadMoreVisible: data.length === this.messagesLimit,
      })))
      .then(() => {
        process.nextTick(() => {
          const chatMessagesHeightAfter = chatMessagesElement.offsetHeight;
          scrollableContainer.scrollTop = chatMessagesHeightAfter - chatMessagesHeightBefore;
        });
      });
  }

  handleRoomAccess = (room) => {
    this.setState((state) => {
      const isAccessible = !room.deleted
                           && (room.type === 'open' || !!_.find(room.participants, p => p.id === state.currentUserId));
      return { isAccessible };
    });
  }

  handleNewMessage = (data) => {
    if (data.room_id !== this.props.data.room_id) return;
    this.setState(prevState => ({ messages: [...prevState.messages, data] }));
  }

  handleUpdatedMessage = (data) => {
    this.setState((prevState) => {
      const messages = [...prevState.messages];
      const index = _.findIndex(messages, { id: data.id });

      messages.splice(index, 1, data);
      return { messages };
    });
  }

  render() {
    const {
      state: {
        isAccessible,
        messages,
        loadMoreVisible,
      },
      props: {
        data: {
          current_user_id: currentUserId,
          room_id: roomId,
        },
      },
    } = this;

    return (
      <div className="chat">
        <Conversation
          currentUserId={currentUserId}
          messages={messages}
          onLoadMessages={this.handleMessagesLoading}
          loadMore={loadMoreVisible}
        />

        {!isAccessible ? (
          <p className="chat__info">Room was closed by owner</p>
        ) : (
          <MessageForm
            roomId={roomId}
            currentUserId={currentUserId}
          />
        )}
      </div>
    );
  }
}

Chat.propTypes = {
  data: PropTypes.shape({
    current_user_id: PropTypes.number.isRequired,
    is_accessible: PropTypes.bool.isRequired,
    room_id: PropTypes.number.isRequired,
    messages: PropTypes.array.isRequired,
  }).isRequired,
};

export default Chat;
