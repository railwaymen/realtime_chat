import React, { Component } from 'react';

import AttachmentsItem from './AttachmentsItem';

class Attachments extends Component {
  render() {
    const { attachments, editable, onDelete } = this.props;

    return (
      <div className="attachments">
        {attachments.map(attachment => (
          <AttachmentsItem 
            key={attachment.id}
            attachment={attachment}
            editable={editable}
            onDelete={onDelete}
          />
        ))}
      </div>
    );
  }
}
 
export default Attachments;