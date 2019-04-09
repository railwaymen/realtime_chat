// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  $('#new_room_message').on('ajax:success', function(a, b,c ) {
    $(this).find('input[type="text"]').val('');
  });
});

var messageTemplate = _.template(' \
<div class="chat-message-container"> \
  <div class="row no-gutters"> \
    <div class="col-auto text-center"> \
      <%= username %> \
    </div> \
    <div class="col"> \
      <div class="message-content"> \
        <p class="mb-1"><%= message %></p> \
        <div class="text-right"> \
          <small><%= updatedAt %></small> \
        </div> \
      </div> \
    </div> \
  </div> \
</div>')

$(function() {
  $('[data-channel-subscribe="room"]').each(function(index, element) {
    var $element = $(element),
        room_id = $element.data('room-id')

    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)
    
    App.cable.subscriptions.create(
      {
        channel: "RoomChannel",
        room: room_id
      },
      {
        received: function(data) {
          var content = messageTemplate({ username: data.username, message: data.message, updatedAt: data.updated_at })
          $element.append(content);
          $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);
        }
      }
    );
  });
});