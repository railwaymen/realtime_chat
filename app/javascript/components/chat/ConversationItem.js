import React, { Component } from 'react';

import moment from 'moment';

import { updateMessage, deleteMessage } from '@/actions/chat';
import markdownRenderer from '@/utils/markdown_renderer';

class ConverationItem extends Component {
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
    const { currentUserId, message: { user_id } } = this.props;
    if (currentUserId === user_id) this.setState({ editing: true });
  }

  handleMessageEdit = () => {
    if (this.state.value !== '') {
      const params = {
        id: this.props.message.id,
        body: this.state.value,
      };

      updateMessage(params, () => {
        this.setState({ editing: false });
      });
    }
  }

  handleMessageDelete = () => {
    if (confirm('Are you sure?')) deleteMessage({ id: this.props.message.id });
  }

  render() {
    const {
      message: {
        body,
        user_id,
        created_at,
        edited,
        deleted,
        user: {
          username,
        },
      },
      currentUserId,
    } = this.props;

    const classes = ['message'];
    classes.push(currentUserId === user_id ? 'message--own' : 'message--foreign');

    return (
      <div className={classes.join(' ')}>
        <div className="message__info">
          <span className="username">{username}</span>
          <span className="date">{moment(created_at).format('LLL')}</span>
          {edited && <span className="edited">(edited)</span>}
        </div>

        <div className="message__container">
          {this.state.editing ? (
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
                  &times;
                </button>

                <button
                  onClick={this.handleMessageEdit}
                  className="btn btn-outline-secondary"
                  type="button"
                >
                  &#10003;
                </button>
              </div>
            </div>
          ) : (
            <div className="message__body" onDoubleClick={this.handleDoubleClick}>
              <p dangerouslySetInnerHTML={{ __html: markdownRenderer.render(body) }} />

              {!deleted && currentUserId === user_id && (
                <div className="message__actions">
                  <span
                    className="edit"
                    onClick={this.handleDoubleClick}
                  >
                    &#128394;
                  </span>

                  <span
                    className="destroy"
                    onClick={this.handleMessageDelete}
                  >
                    &#128465;
                  </span>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    );
  }
}

export default ConverationItem;
