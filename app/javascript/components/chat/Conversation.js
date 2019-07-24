import React, { Component } from 'react';
import PropTypes from 'prop-types';

import MessagesBubble from './MessagesBubble';
import groupMessagesService from '@/utils/group_messages_service';

class Conversation extends Component {
  componentDidMount() {
    this.scrollToBottom();
  }

  componentDidUpdate(prevProps) {
    if (prevProps.messages.length === 0) return;

    if (_.last(prevProps.messages).id !== _.last(this.props.messages).id) {
      this.scrollToBottom();
    }
  }

  scrollToBottom = () => {
    const lastMessage = document.querySelector('.chat__messages .bubble:last-of-type');
    if (lastMessage) lastMessage.scrollIntoView(false);
  }

  render() {
    const {
      messages,
      currentUserId,
      onLoadMessages,
      loadMore,
    } = this.props;

    return (
      <div className="chat__conversation">
        {loadMore && (
          <div className="chat__load-more">
            <button
              type="button"
              className="btn btn-light"
              onClick={onLoadMessages}
            >
              Previous messages ...
            </button>
          </div>
        )}
        <div className="chat__messages">
          {messages.length > 0 ? (
            _.map(groupMessagesService(messages), (bubbleMessages, index) => (
              <MessagesBubble key={index} messages={bubbleMessages} currentUserId={currentUserId} />
            ))
          ) : (
            <p>There are no messages</p>
          )}
        </div>
      </div>
    );
  }
}

Conversation.propTypes = {
  currentUserId: PropTypes.number.isRequired,
  messages: PropTypes.arrayOf(PropTypes.object).isRequired,
  onLoadMessages: PropTypes.func.isRequired,
  loadMore: PropTypes.bool.isRequired,
};

export default Conversation;
