const initializeRoomsJoin = () => {
  $('form.button_to').on('ajax:success', (event) => {
    const joinBtn = $(event.target).find('input[type="submit"]');

    joinBtn.prop('disabled', true);
    joinBtn.prop('value', 'Joined!');
  });
};

export default initializeRoomsJoin;