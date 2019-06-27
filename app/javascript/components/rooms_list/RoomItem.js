import React, { Component } from 'react';

function RoomItem(props) {
  const {
    room: {
      name,
      user_id,
      room_path,
    },
    currentUserId,
  } = props;

  const classes = ['room__item'];
  if (user_id === currentUserId) classes.push('room__item--own');

  return (
    <div className={classes.join(' ')}>
      <a href={room_path}>{name}</a>
    </div>
  );
}

export default RoomItem;
