import React, { Component } from 'react';

import Conversation from './Conversation';

import { createMessage } from '@/actions/chat'
import createChannel from '@/utils/cable';

class Chat extends Component {
  constructor(props) {
    super(props)

    this.state = {
      isRoomDeleted: props.data.room_deleted,
      messages: props.data.messages,
      currentUserId: props.data.current_user_id,
      currentMessage: '',
      typers: []
    }

    this.subscription = createChannel(
      {
        channel: 'RoomChannel',
        room: props.data.room_id
      },
      {
        received: response => {
          if (response.message === 'typing') {
            this.handleTypingAction(response)
            return;
          }
          
          switch (response.type) {
            case 'create':
              this.handleNewMessage(response.data)
              break;
            case 'update':
              this.handleUpdatedMessage(response.data)
              break;
            case 'destroy':
              this.handleUpdatedMessage(response.data)
              break;  
            case 'room_close':
              this.handleClosedRoom()
          }
        },
        userTyping: typing => {
          this.subscription.perform('user_typing', { typing: typing, room_id: props.data.room_id })
        }
      }
    )
  }

  handleClosedRoom = () => {
    this.setState({ isRoomDeleted: true })
  }

  handleMessageChange = e => {
    this.setState({ currentMessage: e.target.value })
  }

  handleNewMessage = data => {
    const messages = [...this.state.messages, data]
    this.setState({ messages })
  }

  handleUpdatedMessage = data => {
    const messages = [...this.state.messages]
    const index = _.findIndex(messages, { id: data.id })

    messages.splice(index, 1, data)
    this.setState({ messages })
  }

  handleTypingAction = data => {
    const typers = _.uniqBy([data.user, ...this.state.typers], 'id')

    if (!data.typing || data.user.id == this.state.currentUserId) {
      const index = typers.indexOf(data.user)
      typers.splice(index, 1)
    }

    this.setState({ typers })
  }

  handleUserTyping = e => {
    this.setState({ currentMessage: e.target.value })
    this.subscription.userTyping(e.target.value != '')
  }

  handleMessageSubmit = e => {
    e.preventDefault()

    if (this.state.currentMessage != '') {
      const params = {
        room_id: this.props.data.room_id,
        body: this.state.currentMessage
      }

      createMessage(params, () => {
        this.setState({ currentMessage: '' })
        this.subscription.userTyping(false)
      })
    }
  }

  render() {
    const {
      isRoomDeleted,
      messages,
      currentUserId,
      currentMessage,
      typers
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
    )
  }
}

export default Chat;