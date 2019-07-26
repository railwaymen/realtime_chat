/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

/* eslint-disable import/newline-after-import, import/first, no-unused-vars */

import _ from 'lodash';
import 'bootstrap/dist/js/bootstrap';

import Rails from 'rails-ujs';
import * as ActiveStorage from 'activestorage';

// Chat
import initializeChat from '@/initializers/chat';
window.initializeChat = initializeChat;

// RoomsList
import initializeRoomsList from '@/initializers/rooms_list';
window.initializeRoomsList = initializeRoomsList;

// RoomsJoin
import initializeRoomsJoin from '@/initializers/rooms_join';
window.initializeRoomsJoin = initializeRoomsJoin;

// Chat
import initializeUsersSelect from '@/initializers/users_select';
window.initializeUsersSelect = initializeUsersSelect;

/* eslint-enable import/newline-after-import, import/first */

Rails.start();
ActiveStorage.start();

$(() => {
  console.log(`jquery version ${$.fn.jquery}`);
  console.log(`bootstrap version ${$.fn.tooltip.Constructor.VERSION}`);
});
