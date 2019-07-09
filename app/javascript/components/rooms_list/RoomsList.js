import React, { Component } from 'react';
import Push from 'push.js';

import createChannel from '@/utils/cable';
import playAudio from '@/utils/audio_player';

import RoomItem from './RoomItem';

class RoomsList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      currentUserId: props.data.current_user.id,
      userActivity: props.data.current_user.rooms_activity,
      rooms: props.data.rooms,
      filteredRooms: props.data.rooms,
      searchValue: '',
    };

    this.appSubscription = createChannel(
      {
        channel: 'AppChannel',
      },
      {
        received: this.handleChannelResponse,
      },
    );

    this.userSubscription = createChannel(
      {
        channel: 'UserChannel',
      },
      {
        received: this.handleChannelResponse,
      },
    );
  }

  filterRooms = () => {
    const { searchValue, rooms } = this.state;
    let filteredRooms;

    if (searchValue.length > 0) {
      filteredRooms = rooms.filter(room => room.name.toLowerCase().indexOf(searchValue.toLowerCase()) > -1);
    } else {
      filteredRooms = [...rooms];
    }

    this.setState({ filteredRooms });
  }

  handleChannelResponse = (response) => {
    switch (response.type) {
      case 'room_create':
      case 'room_open':
        this.handleNewRoom(response.data);
        break;
      case 'room_update':
        this.handleUpdatedRoom(response.data);
        break;
      case 'room_close':
        this.handleClosedRoom(response.data);
        break;
      case 'room_message_create':
        this.updateUserActivity(response.data);
        break;
      default:
        break;
    }
  }

  handleNewRoom = (room) => {
    const sortedRooms = _.orderBy([...this.state.rooms, room], [r => r.name.toLowerCase()], ['asc']);
    this.setState({ rooms: _.uniqBy(sortedRooms, 'id') });
    this.filterRooms();
  }

  handleUpdatedRoom = (room) => {
    const rooms = [...this.state.rooms];
    const index = _.findIndex(rooms, { id: room.id });

    rooms.splice(index, 1, room);

    const sortedRooms = _.orderBy(rooms, [r => r.name.toLowerCase()], ['asc']);
    this.setState({ rooms: sortedRooms });
    this.filterRooms();
  }

  handleClosedRoom = (room) => {
    this.setState((prevState) => {
      const rooms = [...prevState.rooms];
      const index = _.findIndex(rooms, { id: room.id });

      rooms.splice(index, 1);
      return { rooms };
    });

    this.filterRooms();
  }

  updateUserActivity = (message) => {
    this.setState((prevState) => {
      const rooms = [...prevState.rooms];
      const room = _.find(rooms, { id: message.room_id });

      room.last_message_at = message.created_at;
      return { rooms };
    });

    if (message.user_id !== this.state.currentUserId) {
      playAudio(this.props.data.sound_path);

      Push.create(`${message.user.username} is writing`, {
        body: _.truncate(message.body),
        timeout: 6000,
        onClick() {
          window.focus();
          this.close();
        },
      });
    }
  }

  handleSearch = async (e) => {
    await this.setState({ searchValue: e.target.value });
    this.filterRooms();
  }

  unreadMessage = room => (
    room.last_message_at && new Date(room.last_message_at) > new Date(this.state.userActivity[room.id])
  )

  render() {
    const {
      filteredRooms,
      currentUserId,
      searchValue,
    } = this.state;

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
          {filteredRooms.map(room => (
            <RoomItem
              key={room.id}
              room={room}
              currentUserId={currentUserId}
              unreadMessage={this.unreadMessage(room)}
            />
          ))}
        </div>
      </div>
    );
  }
}

export default RoomsList;
