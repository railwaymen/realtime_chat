import React from 'react';
import PropTypes from 'prop-types';

function RoomItem(props) {
  const {
    room: {
      name,
      room_path: roomPath,
      participants,
      type,
    },
    currentUserId,
  } = props;

  const roomName = type === 'direct'
    ? _.reject(participants, { id: currentUserId }).map(x => x.username).join(', ')
    : name;

  return (
    <li className="rooms-item">
      <a href={roomPath}>{roomName}</a>
    </li>
  );
}

RoomItem.propTypes = {
  room: PropTypes.shape({
    name: PropTypes.string.isRequired,
    room_path: PropTypes.string.isRequired,
    participants: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.number.isRequired,
        username: PropTypes.string.isRequired,
      }),
    ),
    type: PropTypes.string.isRequired,
  }).isRequired,
  currentUserId: PropTypes.number.isRequired,
};

export default RoomItem;
