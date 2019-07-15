import React, { Component } from 'react';

import attachmentIconsMapper from '@/utils/attachment_icons_mapper';

class AttachmentsItem extends Component {
  render() {
    const { attachment, editable, onDelete } = this.props;

    const extension = _.last(attachment.file_identifier.split('.'))

    return (
      <div className="attachment">
        <a href={attachment.url} target="_blank">
          {attachment.content_type.indexOf('image') !== -1 ? (
            <img src={attachment.thumb_url} />
          ) : (
            <span className="attachment__placeholder">
              <i className={ `icofont-file-${attachmentIconsMapper(extension)}` }></i>
            </span>
          )}
        </a>
        { editable && (
          <span className="attachment__delete" onClick={() => onDelete(attachment.id)}>
            <i className="icofont-close-circled"></i>
          </span>
        )}
      </div>
    );
  }
}
 
export default AttachmentsItem;