// React
import React from 'react';
import ReactDOM from 'react-dom';

// Components
import RoomsList from '@/components/rooms_list/RoomsList';

const initializeRoomsList = (data) => {
  const roomsLists = document.querySelectorAll('.rooms__list[data-behavior="react"]');

  const {
    rooms,
    current_user: currentUser,
    sound_path: soundPath,
  } = data;

  const groupedRooms = _.groupBy(rooms, 'type');
  
  roomsLists.forEach((roomList) => {
    const roomType = roomList.dataset.type;
    
    ReactDOM.render(
      <RoomsList
        roomType={roomType}
        rooms={groupedRooms[roomType]}
        currentUser={currentUser}
        soundPath={soundPath}
      />,
      roomList
    );
  });
};

export default initializeRoomsList;
