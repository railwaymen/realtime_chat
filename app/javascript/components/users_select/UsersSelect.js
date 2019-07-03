import React, { Component } from 'react';
import Select from 'react-select';

class UsersSelect extends Component {
  render() {
    const { options, values } = this.props.data;

    const selectedUsers = options.filter(user => {
      return values.split(',').indexOf(String(user.value)) !== -1
    })

    return (
      <React.Fragment>
        <label>Participants</label>
        <Select
          name='users_ids'
          defaultValue={selectedUsers}
          options={options}
          delimiter=','
          isMulti
        />
      </React.Fragment>
    );
  }
}
 
export default UsersSelect;