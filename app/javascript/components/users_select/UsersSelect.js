import React from 'react';
import PropTypes from 'prop-types';
import Select from 'react-select';

const UsersSelect = (props) => {
  const { options, values } = props.data;

  const selectedUsers = options.filter(user => values.split(',').indexOf(String(user.value)) !== -1);

  return (
    <React.Fragment>
      <label htmlFor="users_ids">Participants</label>
      <Select
        inputId="users_ids"
        name="users_ids"
        defaultValue={selectedUsers}
        options={options}
        delimiter=","
        isMulti
      />
    </React.Fragment>
  );
};

UsersSelect.propTypes = {
  data: PropTypes.shape({
    options: PropTypes.arrayOf(
      PropTypes.shape({
        label: PropTypes.string.isRequired,
        value: PropTypes.number.isRequired,
      }).isRequired,
    ),
    values: PropTypes.string.isRequired,
  }).isRequired,
};

export default UsersSelect;
