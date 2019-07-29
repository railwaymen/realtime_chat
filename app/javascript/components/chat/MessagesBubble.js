import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

import MessageItem from './MessageItem';

const MessagesBubble = (props) => {
  const { messages, currentUserId } = props;
  const firstMessage = messages[0];
  const classes = ['bubble'];

  classes.push(currentUserId === firstMessage.user_id ? 'bubble--own' : 'bubble--foreign');

  return (
    <div className={classes.join(' ')}>
      <div className="bubble__header">
        <div className="avatar">
          <div className="avatar__placeholder">
            <img className="avatar__placeholder rounded-circle" src={firstMessage.user.avatar_url} alt="User avatar" />
          </div>
        </div>

        <div className="bubble__info">
          <span className="username">{firstMessage.user.username}</span>
          <span className="date">{moment(firstMessage.created_at).startOf('minute').format('LLL')}</span>
        </div>
      </div>

      <div className="bubble__body">
        {messages.map(message => (
          <MessageItem key={message.id} message={message} currentUserId={currentUserId} />
        ))}
      </div>
    </div>
  );
};

MessagesBubble.propTypes = {
  messages: PropTypes.arrayOf(PropTypes.object).isRequired,
  currentUserId: PropTypes.number.isRequired,
};

export default MessagesBubble;
