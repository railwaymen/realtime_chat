import React from 'react';

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

export default RoomItem;
