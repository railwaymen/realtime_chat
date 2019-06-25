import React, { Component } from 'react';

import createChannel from '@/utils/cable';

import RoomItem from './RoomItem'

class RoomsList extends Component {
  constructor(props) {
    super(props)

    this.state = {
      currentUserId: props.data.current_user_id,
      rooms: props.data.rooms,
      searchValue: ''
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

  handleSearch = e => {
    const value = e.target.value
    let rooms;

    if (value.length > 0) {
      rooms = this.props.data.rooms.filter(room => {
        return room.name.toLowerCase().indexOf(value.toLowerCase()) > -1
      })
    } else {
      rooms = this.props.data.rooms
    }
    
    this.setState({ searchValue: value, rooms: rooms })
  }

  render() {
    const { rooms, currentUserId, searchValue } = this.state;

    return (
      <div className="rooms">
        <div className="rooms__search py-2">
          <input
            value={searchValue}
            className="form-control"
            type="text"
            placeholder="Search..."
            onChange={this.handleSearch}
          />
        </div>

        <div className="rooms__list mb-2">
          {rooms.map(room => (
            <RoomItem key={room.id} room={room} currentUserId={currentUserId} />
          ))}
        </div>
      </div>
    )
  }
}

export default RoomsList;
