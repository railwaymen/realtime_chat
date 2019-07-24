import moment from 'moment';

const minuteTimestamp = datetime => (
  moment(datetime).startOf('minute').unix()
);

const groupMessagesService = (messages) => {
  const outputMessages = {};
  if (messages.length === 0) return outputMessages;

  let currentGroupId = 0;
  let prevMessage = {};

  messages.forEach((message) => {
    if (
      message.user_id !== prevMessage.user_id
      || minuteTimestamp(message.created_at) !== minuteTimestamp(prevMessage.created_at)
    ) {
      currentGroupId += 1;
    }

    const messagesGroup = outputMessages[currentGroupId] || [];
    messagesGroup.push(message);

    outputMessages[currentGroupId] = messagesGroup;
    prevMessage = message;
  });

  return outputMessages;
};

export default groupMessagesService;
