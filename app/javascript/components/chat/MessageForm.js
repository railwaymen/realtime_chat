import React, { Component } from 'react';
import PropTypes from 'prop-types';

import Attachments from './Attachments';
import { createMessage, uploadFile, deleteFile } from '@/actions/chat';
import createChannel from '@/utils/cable';

class MessageForm extends Component {
  charsCount = 0

  constructor(props) {
    super(props);

    this.state = {
      message: '',
      attachments: [],
      typers: [],
    };

    this.roomSubscription = createChannel(
      {
        channel: 'RoomChannel',
        room_id: props.roomId,
      },
      {
        received: (response) => {
          if (response.message === 'typing') {
            this.handleTypingAction(response);
          }
        },
        userTyping: (typing) => {
          this.roomSubscription.perform('user_typing', { typing, room_id: props.roomId });
        },
      },
    );
  }

  handleAttachmentButton = (e) => {
    e.preventDefault();
    document.getElementById('attachments_input').click();
  }

  handleAttachmentUpload = (e) => {
    if (e.target.files[0] === undefined) return;

    const formData = new FormData();
    formData.append('file', e.target.files[0]);

    uploadFile(formData)
      .then(response => response.json())
      .then(attachment => this.setState(prevState => ({
        attachments: [...prevState.attachments, attachment],
      })));
  }

  handleAttachmentDelete = (id) => {
    deleteFile(id)
      .then(() => {
        this.setState(prevState => ({
          attachments: prevState.attachments.filter(attachment => attachment.id !== id),
        }));
      });
  }

  handleMessageChange = (e) => {
    this.setState({ message: e.target.value });
  }

  handleMessageSubmit = (e) => {
    e.preventDefault();

    const {
      props: { roomId },
      state: { message, attachments },
    } = this;

    if (message !== '') {
      const params = {
        message: { body: message.trim(), room_id: roomId },
        attachment_ids: _.map(attachments, 'id'),
      };

      createMessage(params)
        .then(() => {
          this.setState({ message: '', attachments: [] });
          this.roomSubscription.userTyping(false);
        });
    }
  }

  handleTypingAction = (data) => {
    this.setState((prevState) => {
      const typers = _.uniqBy([data.user, ...prevState.typers], 'id');

      if (!data.typing || data.user.id === this.props.currentUserId) {
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
      this.setState({ message: e.target.value });
      this.roomSubscription.userTyping(e.target.value !== '');
    }
    this.charsCount = currentCharsCount;
  }

  renderTypingMessage = () => {
    const typers = _.map(this.state.typers, 'username');

    switch (typers.length) {
      case 0:
        return <span />;
      case 1:
        return <span>{ `${typers[0]} is typing ...` }</span>;
      case 2:
        return <span>{ `${typers.join(' and ')} are typing ...` }</span>;
      default:
        return <span>{ `${typers[0]} and ${typers.length - 1} other people are typing ...` }</span>;
    }
  }

  render() {
    const { message, attachments } = this.state;

    return (
      <div className="chat__message-form">
        <div className="chat__typers">
          {this.renderTypingMessage()}
        </div>

        <form onSubmit={this.handleMessageSubmit}>
          <div className="form-group">
            <div className="input-group">
              <textarea
                value={message}
                onChange={this.handleMessageChange}
                onKeyUp={this.handleUserTyping}
                className="form-control"
              />
              <div className="input-group-append">
                <button
                  type="button"
                  onClick={this.handleAttachmentButton}
                  className="btn btn-dark"
                >
                  <i className="icofont-attachment icofont-2x" />
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
    );
  }
}

MessageForm.propTypes = {
  roomId: PropTypes.number.isRequired,
  currentUserId: PropTypes.number.isRequired,
};

export default MessageForm;
