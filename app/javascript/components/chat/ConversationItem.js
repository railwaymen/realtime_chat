import React, { Component } from 'react'

class ConverationItem extends Component {
  render() {
    const {
      message: {
        body,
        user_id,
        created_at,
        user: {
          username
        }
      },
      currentUserId
    } = this.props;

    let classes = ['message']

    currentUserId == user_id ? classes.push('message__own') : classes.push('message__foreign')

    return (
      <div className={classes.join(' ')}>
        <div className="message__info">
          <span className="username">{username}</span>
          <span className="date">{created_at}</span>
        </div>

        <p className="message__body">
          {body}
        </p>
      </div>
    )
  }
}

export default ConverationItem;