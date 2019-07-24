import React, { Component } from 'react';
import PropTypes from 'prop-types';

import Attachments from './Attachments';

import { updateMessage, deleteMessage } from '@/actions/chat';
import markdownRenderer from '@/utils/markdown_renderer';

class MessageItem extends Component {
  constructor(props) {
    super(props);

    this.state = {
      editing: false,
      value: props.message.body,
    };
  }

  handleBodyChange = (e) => {
    this.setState({ value: e.target.value });
  }

  handleEditingCancel = () => {
    this.setState({ editing: false, value: this.props.message.body });
  }

  handleDoubleClick = () => {
    const { currentUserId, message: { user_id: userId } } = this.props;
    if (currentUserId === userId) this.setState({ editing: true });
  }

  handleMessageEdit = () => {
    if (this.state.value !== '') {
      const params = {
        id: this.props.message.id,
        body: this.state.value,
      };

      updateMessage(params)
        .then(() => this.setState({ editing: false }));
    }
  }

  handleMessageDelete = () => {
    if (window.confirm('Are you sure?')) deleteMessage({ id: this.props.message.id });
  }

  render() {
    const {
      message: {
        attachments,
        body,
        user_id: userId,
        edited,
        deleted,
      },
      currentUserId,
    } = this.props;

    return (
      <div className="message">
        <div className="message__container">
          {!deleted && this.state.editing ? (
            <div className="input-group">
              <textarea
                className="form-control"
                value={this.state.value}
                onChange={this.handleBodyChange}
              />
              <div className="input-group-append">
                <button
                  onClick={this.handleEditingCancel}
                  className="btn btn-outline-secondary"
                  type="button"
                >
                  <i className="icofont-close-line" />
                </button>

                <button
                  onClick={this.handleMessageEdit}
                  className="btn btn-outline-secondary"
                  type="button"
                >
                  <i className="icofont-check-alt" />
                </button>
              </div>
            </div>
          ) : (
            <div className="message__body" onDoubleClick={this.handleDoubleClick}>
              <div dangerouslySetInnerHTML={{ __html: markdownRenderer.render(body) }} />
              {edited && !deleted && <div className="message__edited">(edited)</div>}

              {!deleted && currentUserId === userId && (
                <div className="message__actions">
                  <span
                    className="edit"
                    onClick={this.handleDoubleClick}
                  >
                    <i className="icofont-edit-alt" />
                  </span>

                  <span
                    className="destroy"
                    onClick={this.handleMessageDelete}
                  >
                    <i className="icofont-ui-delete" />
                  </span>
                </div>
              )}
            </div>
          )}

          <div className="message__attachments">
            <Attachments attachments={attachments} />
          </div>
        </div>
      </div>
    );
  }
}

MessageItem.propTypes = {
  message: PropTypes.shape({
    attachments: PropTypes.arrayOf(PropTypes.object),
    body: PropTypes.string,
    created_at: PropTypes.string.isRequired,
    deleted: PropTypes.bool.isRequired,
    edited: PropTypes.bool.isRequired,
    id: PropTypes.number.isRequired,
    user: PropTypes.shape({
      id: PropTypes.number.isRequired,
      username: PropTypes.string.isRequired,
    }).isRequired,
    user_id: PropTypes.number.isRequired,
  }).isRequired,
  currentUserId: PropTypes.number.isRequired,
};

export default MessageItem;
