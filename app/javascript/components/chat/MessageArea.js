import React, { Component } from 'react'

class MessageArea extends Component {
  handleFormSubmit = e => {
    e.preventDefault()
    this.props.onSubmit(e)
  }

  render() {
    const { value, onChange, onType } = this.props;

    return (
      <form onSubmit={this.handleFormSubmit} className="message-area">
        <div className="input-group">
          <input
            value={value}
            onChange={onChange}
            onKeyUp={onType}
            className="form-control"
          />
          <div className="input-group-append">
            <button type="submit" className="btn btn-primary">Send</button>
          </div>
        </div>
      </form>
      
    )
  }
}

export default MessageArea;