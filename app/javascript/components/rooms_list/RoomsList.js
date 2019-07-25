import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Push from 'push.js';

import createChannel from '@/utils/cable';
import playAudio from '@/utils/audio_player';

import RoomItem from './RoomItem';

class RoomsList extends Component {
  constructor(props) {
    super(props)

    this.state = {
      rooms: props.rooms || [],
      userActivity: props.currentUser.rooms_activity,
    }

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

  handleChannelResponse = (response) => {
    if (response.data.type !== this.props.roomType) return;

    switch (response.type) {
      case 'room_create':
      case 'room_open':
        this.handleNewRoom(response.data);
        break;
      case 'room_update':
        this.handleUpdatedRoom(response.data);
        break;
      case 'room_close':
        this.handleDeletedRoom(response.data);
        break;
      case 'room_message_create':
        this.handleNewMessageNotification(response.data);
        break;
      default:
        break;
    }
  }

  handleNewRoom = (room) => {
    const sortedRooms = _.orderBy([...this.state.rooms, room], [r => r.name.toLowerCase()], ['asc']);
    this.setState({ rooms: _.uniqBy(sortedRooms, 'id') });
  }

  handleUpdatedRoom = (room) => {
    const rooms = [...this.state.rooms];
    const index = _.findIndex(rooms, { id: room.id });

    rooms.splice(index, 1, room);

    const sortedRooms = _.orderBy(rooms, [r => r.name.toLowerCase()], ['asc']);
    this.setState({ rooms: sortedRooms });
  }

  handleDeletedRoom = (room) => {
    this.setState((prevState) => {
      const rooms = [...prevState.rooms];
      const index = _.findIndex(rooms, { id: room.id });

      rooms.splice(index, 1);
      return { rooms };
    });
  }

  handleNewMessageNotification = (message) => {
    this.setState((prevState) => {
      const rooms = [...prevState.rooms];
      const room = _.find(rooms, { id: message.room_id });

      room.last_message_at = message.created_at;
      return { rooms };
    });

    if (message.user_id !== this.state.currentUserId) {
      playAudio(this.props.soundPath);

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

  hasUnreadMessage = room => (
    Boolean(room.last_message_at && new Date(room.last_message_at) > new Date(this.state.userActivity[room.id]))
  )

  render() {
    const { 
      state: { rooms },
      props: { currentUser }
    } = this;

    return (
      <ul>
        {rooms.map(room => (
          <RoomItem
            key={room.id}
            room={room}
            currentUserId={currentUser.id}
            unreadMessage={this.hasUnreadMessage(room)}
          />
        ))}
      </ul>
    );
  }
}

RoomsList.propTypes = {
  currentUser: PropTypes.shape({
    id: PropTypes.number.isRequired,
    rooms_activity: PropTypes.objectOf(PropTypes.string).isRequired,
  }).isRequired,
  rooms: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      name: PropTypes.string.isRequired,
      last_message_at: PropTypes.string,
    }),
  ),
  soundPath: PropTypes.string.isRequired,
  roomType: PropTypes.string.isRequired,
};

export default RoomsList;
