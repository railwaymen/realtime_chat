import React, { Component } from 'react';
import PropTypes from 'prop-types';

import Peer from 'simple-peer';

import Conversation from './Conversation';
import MessageForm from './MessageForm';

import { loadMessages, updateActivity } from '@/actions/chat';
import createChannel from '@/utils/cable';

class Chat extends Component {
  messagesLimit = 20

  constructor(props) {
    super(props);

    this.videoRef = React.createRef()

    this.state = {
      isAccessible: props.data.is_accessible,
      messages: props.data.messages,
      currentUserId: props.data.current_user_id,
      loadMoreVisible: props.data.messages.length === this.messagesLimit,
      videoInitiated: false,
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
    this.roomSubscription = createChannel(
      {
        channel: 'RoomChannel',
        room_id: this.props.data.room_id,
      },
      {
        received: (response) => {
          if (response.user.id === this.state.currentUserId) return;
          console.log('=====================response')
          console.log(response)
          console.log('======================response')
          if (response.message === 'video') {
            this.responseOffer(response.data);
          }
        },
      },
    );

    window.onbeforeunload = () => {
      updateActivity(props.data.room_id);
    };
  }

  handleChannelResponse = (response) => {
    switch (response.type) {
      case 'room_message_create':
        this.handleNewMessage(response.data);
        break;
      case 'room_message_update':
      case 'room_message_destroy':
        this.handleUpdatedMessage(response.data);
        break;
      case 'room_open':
      case 'room_close':
        this.handleRoomAccess(response.data);
        break;
      default:
        break;
    }
  }

  handleMessagesLoading = () => {
    const firstMessage = document.querySelector('.chat__messages .message:first-of-type');
    const oldFirstMessageTopOffset = firstMessage.offsetTop;

    const params = {
      roomId: this.props.data.room_id,
      lastId: this.state.messages[0].id,
      limit: this.messagesLimit,
    };

    loadMessages(params)
      .then(response => response.json())
      .then(data => this.setState(prevState => ({
        messages: [...data, ...prevState.messages],
        loadMoreVisible: data.length === this.messagesLimit,
      })))
      .then(() => {
        process.nextTick(() => {
          const scrollableContainer = document.querySelector('.chat__conversation');
          const newFirstMessageTopOffset = firstMessage.offsetTop;

          scrollableContainer.scrollTop = newFirstMessageTopOffset - oldFirstMessageTopOffset;
        });
      });
  }

  handleRoomAccess = (room) => {
    this.setState((state) => {
      const isAccessible = !room.deleted
                           && (room.type === 'open' || !!_.find(room.participants, p => p.id === state.currentUserId));
      return { isAccessible };
    });
  }

  handleNewMessage = (data) => {
    if (data.room_id !== this.props.data.room_id) return;
    this.setState(prevState => ({ messages: [...prevState.messages, data] }));
  }

  handleUpdatedMessage = (data) => {
    this.setState((prevState) => {
      const messages = [...prevState.messages];
      const index = _.findIndex(messages, { id: data.id });

      messages.splice(index, 1, data);
      return { messages };
    });
  }


  shareMedia = (e) => {
    navigator.getUserMedia({ video: true, audio: true }, (stream) => {
      console.log('shareMedia')
      if (!!this.me) return;
      this.me  = new Peer({ initiator: true, stream: stream, trickle: false })

      this.me.on('signal', data => {
        this.roomSubscription.perform('video', { data, room_id: this.props.data.room_id });
        console.log('on signal');
      });

      this.me.on('connect', () => {
        console.log('CONNECT')
      })

      this.me.on('stream', stream => {
        // got remote video stream, now let's show it in a video tag
        console.log('this.videoRef')
        console.log(this.videoRef)
        console.log('this.videoRef')
        console.log('stream')
        console.log(stream)
        console.log('stream')
        if ('srcObject' in this.videoRef) {
          this.videoRef.srcObject = stream
        } else {
          this.videoRef.src = window.URL.createObjectURL(stream) // for older browsers
        }

        this.videoRef.play()
      })
    }, () => { });
  }

  responseOffer = (data) => {
    console.log('responseOffer')
    navigator.getUserMedia({ video: true, audio: true }, (stream) => {
      console.log('getUserMedia')
      if (!!this.me) return;
      this.me = new Peer({ initiator: false, stream: stream, trickle: false })

      this.me.on('signal', data => {
        this.roomSubscription.perform('video', { data, room_id: this.props.data.room_id });
        console.log('on signal');
      });

      this.me.on('connect', () => {
        console.log('CONNECT')
      })

      this.me.on('stream', stream => {
        // got remote video stream, now let's show it in a video tag
        console.log('this.videoRef')
        console.log(this.videoRef)
        console.log('this.videoRef')
        console.log('stream')
        console.log(stream)
        console.log('stream')
        if ('srcObject' in this.videoRef) {
          this.videoRef.src = window.URL.createObjectURL(stream) // for older browsers
        } else {
          this.videoRef.srcObject = stream
        }

        this.videoRef.play()
      })

      this.me.signal(data)
    }, () => { });
  }

  render() {
    const {
      state: {
        isAccessible,
        messages,
        loadMoreVisible,
        streamSource,
      },
      props: {
        data: {
          current_user_id: currentUserId,
          room_id: roomId,
        },
      },
    } = this;

    return (
      <div className="chat">
        <button
          onClick={this.shareMedia}
          className="btn btn-outline-secondary"
          type="button"
        >
          <i className="icofont-video" />
        </button>
        <video ref={this.videoRef}></video>
        <Conversation
          currentUserId={currentUserId}
          messages={messages}
          onLoadMessages={this.handleMessagesLoading}
          loadMore={loadMoreVisible}
        />

        {!isAccessible ? (
          <p className="chat__info">Room was closed by owner</p>
        ) : (
          <MessageForm
            roomId={roomId}
            currentUserId={currentUserId}
          />
        )}
      </div>
    );
  }
}

Chat.propTypes = {
  data: PropTypes.shape({
    current_user_id: PropTypes.number.isRequired,
    is_accessible: PropTypes.bool.isRequired,
    room_id: PropTypes.number.isRequired,
    messages: PropTypes.array.isRequired,
  }).isRequired,
};

export default Chat;
