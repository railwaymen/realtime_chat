const csrf = document.querySelector('meta[name=csrf-token]').content;

const headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
}

const createMessage = (message, successCallback) => {
  fetch('/room_messages', {
    method: 'post',
    headers: headers,
    body: JSON.stringify({
      authenticity_token: csrf,
      room_message: message
    })
  })
  .then(response => response.ok && successCallback());
};

const updateMessage = (message, successCallback) => {
  fetch(`/room_messages/${message.id}`, {
    method: 'put',
    headers: headers,
    body: JSON.stringify({
      authenticity_token: csrf,
      room_message: { body: message.body }
    })
  })
  .then(response => response.ok && successCallback());
};

export {
  createMessage,
  updateMessage
};