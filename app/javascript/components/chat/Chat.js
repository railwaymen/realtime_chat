import React, { Component } from 'react';

import createChannel from '@/utils/cable';

import Conversation from './Conversation';

class Chat extends Component {
  constructor(props) {
    super(props)

    this.state = {
      messages: props.data.messages,
      currentMessage: '',
      currentUserId: props.data.current_user_id,
      typers: []
    }

    this.subscription = createChannel(
      {
        channel: 'RoomChannel',
        room: props.data.room_id
      },
      {
        received: data => {
          if (data.message === 'typing') {
            this.handleTypingAction(data)
          } else {
            this.handleNewMessage(data)
          }
        },
        userTyping: typing => {
          this.subscription.perform('user_typing', { typing: typing, room_id: props.data.room_id })
        }
      }
    )
  }

  handleMessageChange = e => {
    this.setState({ currentMessage: e.target.value })
  }

  handleNewMessage = data => {
    const messages = [...this.state.messages, data]
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

    const typing = e.target.value != ''
    this.subscription.userTyping(typing)
  }

  handleMessageSubmit = e => {
    e.preventDefault()

    const params = {
      authenticity_token: document.querySelector('meta[name=csrf-token]').content,
      room_message: {
        room_id: this.props.data.room_id,
        body: this.state.currentMessage
      }
    }

    fetch('/room_messages', {
      method: 'post',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(params)
    })
    .then(response => {
      if (response.ok) {
        this.setState({ currentMessage: '' })
        this.subscription.userTyping(false)
      }
    })
  }

  render() {
    return (
      <div className="chat">
        <Conversation
          currentUserId={this.state.currentUserId}
          messages={this.state.messages}
          typers={this.state.typers}
        />

        <form onSubmit={this.handleMessageSubmit} className="message-area">
          <div className="input-group">
            <input
              value={this.state.currentMessage}
              onChange={this.handleMessageChange}
              onKeyUp={this.handleUserTyping}
              className="form-control"
            />
            <div className="input-group-append">
              <button type="submit" className="btn btn-primary">Send</button>
            </div>
          </div>
        </form>
      </div>
    )
  }
}

export default Chat;