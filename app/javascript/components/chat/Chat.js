import React, { Component } from 'react';
import PropTypes from 'prop-types';

import Conversation from './Conversation';
import Attachments from './Attachments';

import { loadMessages, createMessage, updateActivity, uploadFile, deleteFile } from '@/actions/chat';
import createChannel from '@/utils/cable';

class Chat extends Component {
  messagesLimit = 20

  charCount = 0

  constructor(props) {
    super(props);

    this.state = {
      isAccessible: props.data.is_accessible,
      messages: props.data.messages,
      currentUserId: props.data.current_user_id,
      currentMessage: '',
      loadMoreVisible: props.data.messages.length === this.messagesLimit,
      attachments: [],
      typers: [],
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
        room_id: props.data.room_id,
      },
      {
        received: (response) => {
          if (response.message === 'typing') {
            this.handleTypingAction(response);
          }
        },
        userTyping: (typing) => {
          this.roomSubscription.perform('user_typing', { typing, room_id: props.data.room_id });
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
      const isAccessible = !room.deleted && (room.public || _.includes(room.participants_ids, state.currentUserId));
      return { isAccessible };
    });
  }

  handleMessageChange = (e) => {
    this.setState({ currentMessage: e.target.value });
  }

  handleNewMessage = (data) => {
    if (data.room_id !== this.props.data.room_id) return;

    this.setState((prevState) => {
      const messages = [...prevState.messages, data];
      return { messages };
    });
  }

  handleUpdatedMessage = (data) => {
    this.setState((prevState) => {
      const messages = [...prevState.messages];
      const index = _.findIndex(messages, { id: data.id });

      messages.splice(index, 1, data);
      return { messages };
    });
  }

  handleTypingAction = (data) => {
    this.setState((prevState) => {
      const typers = _.uniqBy([data.user, ...prevState.typers], 'id');

      if (!data.typing || data.user.id === prevState.currentUserId) {
        const index = typers.indexOf(data.user);
        typers.splice(index, 1);
      }

      return { typers };
    });
  }

  handleUserTyping = (e) => {
    if (e.which === 13 && !e.shiftKey) {
      this.handleMessageSubmit(e);
      return;
    }

    const currentCharsCount = e.target.value.length;
    const typingStatusChanged = Boolean(currentCharsCount) !== Boolean(this.charsCount);

    if (typingStatusChanged) {
      this.setState({ currentMessage: e.target.value });
      this.roomSubscription.userTyping(e.target.value !== '');
    }
    this.charsCount = currentCharsCount;
  }

  handleAttachmentsButton = (e) => {
    e.preventDefault()
    document.getElementById('attachments_input').click()
  }

  handleAttachmentUpload = (e) => {
    if (e.target.files[0] === undefined) return;

    const formData = new FormData()
    formData.append('file', e.target.files[0])

    uploadFile(formData)
      .then(response => response.json())
      .then(attachment => this.setState(prevState => ({
        attachments: [...prevState.attachments, attachment]
      })))
  }

  handleAttachmentDelete = (id) => {
    deleteFile(id)
      .then(() => {
        this.setState(prevState => ({
          attachments: prevState.attachments.filter(attachment => attachment.id !== id)
        }))
      })
  }

  handleMessageSubmit = (e) => {
    e.preventDefault();

    const {
      props: {
        data,
      },
      state: {
        currentMessage,
        attachments
      }
    } = this;

    if (currentMessage !== '') {
      const params = {
        message: { body: currentMessage, room_id: data.room_id },
        attachment_ids: _.map(attachments, 'id')
      };

      createMessage(params, () => {
        this.setState({ currentMessage: '', attachments: [] });
        this.roomSubscription.userTyping(false);
      });
    }
  }

  render() {
    const {
      isAccessible,
      messages,
      currentUserId,
      currentMessage,
      loadMoreVisible,
      attachments,
      typers,
    } = this.state;

    return (
      <div className="chat">
        <Conversation
          currentUserId={currentUserId}
          messages={messages}
          typers={typers}
          onLoadMessges={this.handleMessagesLoading}
          loadMore={loadMoreVisible}
        />

        {!isAccessible ? (
          <p className="chat__info">Room was closed by owner</p>
        ) : (
          <div className="chat__message-form">
            <form onSubmit={this.handleMessageSubmit}>
              <div className="form-group">
                <div className="input-group">
                  <textarea
                    value={currentMessage}
                    onChange={this.handleMessageChange}
                    onKeyUp={this.handleUserTyping}
                    className="form-control"
                  />
                  <div className="input-group-append">
                    <button onClick={this.handleAttachmentsButton} className="btn btn-secondary">
                      <i className="icofont-attachment icofont-2x"></i>
                    </button>
                  </div>
                </div>

                <small className="form-text text-muted">
                  <strong>**bold**</strong>
                  |
                  <em>*italic*</em>
                  |
                  &gt; quote
                  | `inline code` | ```preformatted``` | # heading | [placeholder](html://example.com)
                </small>
              </div>
            </form>

            <div className="message__attachments">
              <input
                type="file"
                id="attachments_input"
                style={{ display: 'none' }}
                onChange={this.handleAttachmentUpload}
              />

              <Attachments attachments={attachments} onDelete={this.handleAttachmentDelete} editable />
            </div>
          </div>
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
