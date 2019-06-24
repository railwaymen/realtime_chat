import React, { Component } from 'react';

import createChannel from '@/utils/cable';

class RoomsList extends Component {
  constructor(props) {
    super(props)

    this.state = {
      rooms: props.rooms
    }

    this.subscription = createChannel(
      {
        channel: 'AppChannel'
      },
      {
        received: response => {
          switch (response.type) {
            case 'room_create':
              this.handleNewRoom(response.data)
              break;
            case 'room_update':
              this.handleUpdatedRoom(response.data)
              break;
            case 'room_destroy':
              this.handleDestroyedRoom(response.data)
              break;
          }
        }
      }
    )
  }

  handleNewRoom = room => {
    const sortedRooms = _.orderBy([...this.state.rooms, room], [room => room.name.toLowerCase()], ['asc']);
    this.setState({ rooms: sortedRooms })
  }

  handleUpdatedRoom = room => {
    const rooms = [...this.state.rooms]
    const index = _.findIndex(rooms, { id: room.id })

    rooms.splice(index, 1, room)
    
    const sortedRooms = _.orderBy(rooms, [room => room.name.toLowerCase()], ['asc']);
    this.setState({ rooms: sortedRooms })
  }

  handleDestroyedRoom = room => {
    const rooms = [...this.state.rooms]
    const index = _.findIndex(rooms, { id: room.id })

    rooms.splice(index, 1)

    this.setState({ rooms })
  }

  render() {
    return (
      <div className="rooms__list">
        {this.state.rooms.map(room => (
          <div className="room__item" key={room.id}>
            <a href={room.room_path}>{room.name}</a>
          </div>
        ))}
      </div>
    )
  }
}

export default RoomsList;
