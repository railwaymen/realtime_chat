import React from 'react';
import PropTypes from 'prop-types';

import attachmentIconsMapper from '@/utils/attachment_icons_mapper';

const AttachmentsItem = (props) => {
  const { attachment, editable, onDelete } = props;
  const extension = _.last(attachment.file_identifier.split('.'));

  return (
    <div className="attachment">
      <a href={attachment.url} target="_blank" rel="noopener noreferrer">
        {attachment.content_type.indexOf('image') !== -1 ? (
          <img src={attachment.thumb_url} alt={attachment.file_identifier} />
        ) : (
          <span className="attachment__placeholder">
            <i className={`icofont-file-${attachmentIconsMapper(extension)}`} />
          </span>
        )}
      </a>
      { editable && (
        <span className="attachment__delete" onClick={() => onDelete(attachment.id)}>
          <i className="icofont-close-circled" />
        </span>
      )}
    </div>
  );
};

AttachmentsItem.propTypes = {
  onDelete: PropTypes.func,
  editable: PropTypes.bool,
  attachment: PropTypes.shape({
    content_type: PropTypes.string.isRequired,
    created_at: PropTypes.string.isRequired,
    file_identifier: PropTypes.string.isRequired,
    file_size: PropTypes.number.isRequired,
    id: PropTypes.number.isRequired,
    thumb_url: PropTypes.string,
    url: PropTypes.string.isRequired,
  }).isRequired,
};

AttachmentsItem.defaultProps = {
  onDelete: undefined,
  editable: false,
};

export default AttachmentsItem;
