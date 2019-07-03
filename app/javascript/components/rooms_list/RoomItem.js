import React, { Component } from 'react';

function RoomItem(props) {
  const {
    room: {
      name,
      user_id,
      room_path,
    },
    currentUserId,
    unreadMessage,
  } = props;

  const classes = ['room__item'];
  if (user_id === currentUserId) classes.push('room__item--own');

  if (unreadMessage) classes.push('room__item--unread-message');

  return (
    <div className={classes.join(' ')}>
      <a href={room_path}>{name}</a>
    </div>
  );
}

export default RoomItem;
