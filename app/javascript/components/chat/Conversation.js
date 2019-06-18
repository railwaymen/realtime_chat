import React, { Component } from 'react';

import ConversationItem from './ConversationItem';

class Conversation extends Component {
  renderTypingMessage = () => {
    const typers = _.map(this.props.typers, 'username')

    let result;

    switch (typers.length) {
      case 0:
        result = ''
        break;
      case 1:
        result = `${typers[0]} is typing ...`
        break;
      default:
        result = `${typers.join(', ')} are typing ...`
    }

    return <span>{result}</span>;
  }

  render() {
    const { messages, currentUserId } = this.props;

    return (
      <div className="conversation">
        <div className="conversation__content">
          {messages.length > 0 ? messages.map(message => (
            <ConversationItem key={message.id} message={message} currentUserId={currentUserId} />
          )) : (
            <p>There are no messages</p>
          )}
        </div>

        <div className="conversation__typers">
          {this.renderTypingMessage()}
        </div>
      </div>
    )
  }
}

export default Conversation;