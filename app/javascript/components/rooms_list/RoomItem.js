import React, { Component } from 'react';

class RoomItem extends Component {
  render() {
    const { 
      room: {
        name,
        user_id,
        room_path
      },
      currentUserId
    } = this.props;

    let classes = ['room__item']

    user_id == currentUserId && classes.push('room__item--own')
    // has_unread_messages && classes.push('room__item--unread-message')

    return (
      <div className={classes.join(' ')}>
        <a href={room_path}>{name}</a>
      </div>
    )
  }
}

export default RoomItem;
