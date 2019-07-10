import React from 'react';
import PropTypes from 'prop-types';

function RoomItem(props) {
  const {
    room: {
      name,
      user_id: userId,
      room_path: roomPath,
    },
    currentUserId,
    unreadMessage,
  } = props;

  const classes = ['room__item'];
  if (userId === currentUserId) classes.push('room__item--own');

  if (unreadMessage) classes.push('room__item--unread-message');

  return (
    <div className={classes.join(' ')}>
      <a href={roomPath}>{name}</a>
    </div>
  );
}

RoomItem.propTypes = {
  room: PropTypes.shape({
    name: PropTypes.string.isRequired,
    user_id: PropTypes.number.isRequired,
    room_path: PropTypes.string.isRequired,
  }).isRequired,
  currentUserId: PropTypes.number.isRequired,
  unreadMessage: PropTypes.bool.isRequired,
};

export default RoomItem;
