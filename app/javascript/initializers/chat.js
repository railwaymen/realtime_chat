// React
import React from 'react';
import ReactDOM from 'react-dom';

// Components
import Chat from '@/components/chat/Chat';

const initializeChat = (data) => {
  const el = document.querySelector('#chat__component[data-behavior="react"]');
  if (el != null) ReactDOM.render(<Chat data={data} />, el);
};

export default initializeChat;
