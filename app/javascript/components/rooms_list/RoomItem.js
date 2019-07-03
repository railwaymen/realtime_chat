import React, { Component } from 'react';

function RoomItem(props) {
  const {
    room: {
      name,
      user_id,
      room_path,
      last_message_at,
    },
    currentUserId,
    lastActivity = 0,
  } = props;

  const classes = ['room__item'];
  if (user_id === currentUserId) classes.push('room__item--own');

  const unreadMessages = last_message_at && new Date(last_message_at) > new Date(lastActivity);
  if (unreadMessages) classes.push('room__item--unread-message');

  return (
    <div className={classes.join(' ')}>
      <a href={room_path}>{name}</a>
    </div>
  );
}

export default RoomItem;
