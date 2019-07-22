// React
import React from 'react';
import ReactDOM from 'react-dom';

// Components
import UsersSelect from '@/components/users_select/UsersSelect';

const initializeUsersSelect = (data) => {
  const el = document.querySelector('#users-select__component[data-behavior="react"]');
  if (el != null) ReactDOM.render(<UsersSelect data={data} />, el);

  $('select#room_type').on('change', (e) => {
    const showParticipants = $(e.target).val() === 'closed';
    $(el).toggle(showParticipants);
  });
};

export default initializeUsersSelect;
