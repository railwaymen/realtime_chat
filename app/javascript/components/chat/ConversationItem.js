import React, { Component } from 'react'

import moment from 'moment'

class ConverationItem extends Component {
  render() {
    const {
      message: {
        body,
        user_id,
        created_at,
        edited,
        user: {
          username
        }
      },
      currentUserId
    } = this.props;

    let classes = ['message']
    classes.push(currentUserId == user_id ? 'message--own' : 'message--foreign')

    return (
      <div className={classes.join(' ')}>
        <div className="message__info">
          <span className="username">{username}</span>
          <span className="date" title={moment(created_at).format('LLLL')}>{moment(created_at).fromNow()}</span>
          {edited && <span className="edited">(edited)</span>}
        </div>

        <p className="message__body">
          {body}
        </p>
      </div>
    )
  }
}

export default ConverationItem;