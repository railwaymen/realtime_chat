import React from 'react';
import PropTypes from 'prop-types';

import AttachmentsItem from './AttachmentsItem';

const Attachments = (props) => {
  const { attachments, editable = false, onDelete } = props;

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
};

Attachments.propTypes = {
  attachments: PropTypes.arrayOf(PropTypes.object).isRequired,
  onDelete: PropTypes.func,
  editable: PropTypes.bool,
};

Attachments.defaultProps = {
  onDelete: undefined,
  editable: false,
};

export default Attachments;
