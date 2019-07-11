import React, { Component } from 'react';
import PropTypes from 'prop-types';

import ConversationItem from './ConversationItem';

class Conversation extends Component {
  constructor(props) {
    super(props);
    this.messagesEnd = React.createRef();
  }

  componentDidMount() {
    this.scrollToBottom();
  }

  componentDidUpdate(prevProps) {
    if (_.last(prevProps.messages).id !== _.last(this.props.messages).id) {
      this.scrollToBottom();
    }
  }

  renderTypingMessage = () => {
    const typers = _.map(this.props.typers, 'username');
    const othersCount = typers.length - 1;

    let result;

    switch (typers.length) {
      case 0:
        result = '';
        break;
      case 1:
        result = `${typers[0]} is typing ...`;
        break;
      case 2:
        result = `${typers.join(' and ')} are typing ...`;
        break;
      default:
        result = `${typers[0]} and ${othersCount} other people are typing ...`;
    }

    return <span>{result}</span>;
  }

  scrollToBottom = () => {
    const lastMessage = document.querySelector('.chat__messages .message:last-of-type');
    if (lastMessage) lastMessage.scrollIntoView();
  }

  render() {
    const {
      messages,
      currentUserId,
      onLoadMessges,
      loadMore,
    } = this.props;

    return (
      <div className="chat__conversation">
        {loadMore && (
          <div className="chat__load-more">
            <button
              type="button"
              className="btn btn-light"
              onClick={onLoadMessges}
            >
              Previous messages ...
            </button>
          </div>
        )}
        <div className="chat__messages">
          {messages.length > 0 ? (
            messages.map(message => (
              <ConversationItem key={message.id} message={message} currentUserId={currentUserId} />
            ))
          ) : (
            <p>There are no messages</p>
          )}
        </div>

        <div className="chat__typers">
          {this.renderTypingMessage()}
        </div>
      </div>
    );
  }
}

Conversation.propTypes = {
  currentUserId: PropTypes.number.isRequired,
  messages: PropTypes.arrayOf(PropTypes.object).isRequired,
  typers: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      username: PropTypes.string.isRequired,
    }),
  ).isRequired,
};

export default Conversation;
