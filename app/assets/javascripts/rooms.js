/*global _ App */

const initializeRoom = function(roomId) {
  this.roomId = roomId
  this.$chatBody = $('#chat-body')
  this.$chatTyping = $('#chat-typing-container')
  this.$chatInput = $('#chat-input')
  this.messageTemplate = _.template(' \
  <div class="chat-message-container"> \
    <div class="row no-gutters"> \
      <div class="col-auto text-center"> \
        <%= username %> \
      </div> \
      <div class="col"> \
        <div class="message-content"> \
          <p class="mb-1"><%= body %></p> \
          <div class="text-right"> \
            <small><%= updatedAt %></small> \
          </div> \
        </div> \
      </div> \
    </div> \
  </div>')

  this.typingTemplate = _.template(' \
    <div class="chat-message-container" data-user-id="<%= user_id %>"> \
    <div class="row no-gutters"> \
      <div class="col-auto text-center"> \
        <%= username %> is typing ...\
      </div> \
    </div> \
    </div>')

  const handleReceivedTyping = function(data) {
    if(data.typing && $(`[data-user-id=${data.user.id}]`, this.$chatTyping).length == 0) {
      this.$chatTyping.append(this.typingTemplate({username: data.user.username, user_id: data.user.id}))
    } else if (data.typing == false) {
      $(`[data-user-id=${data.user.id}]`, this.$chatTyping).remove()
    }
  }

  const handleNewMessage = function(data) {
    this.$chatTyping.before(this.messageTemplate({ username: data.username, body: data.body, updatedAt: data.updated_at }))
  }

  const initializeCable = function() {
    roomId = this.roomId
    this.subscription = App.cable.subscriptions.create(
      {
        channel: 'RoomChannel',
        room: this.roomId
      },
      {
        received: function(data) {
          if(data.message == 'typing') {
            handleReceivedTyping(data);
          } else {
            handleNewMessage(data)
          }
        },
        userTyping: function(typing) {
          this.perform('user_typing', { typing: typing, room_id: roomId })
        }
      }
    );
  }

  const initializeListeners = function(subscription){
    this.$chatInput.on('keyup', function(e) {
      var typing = $(e.currentTarget).val() != '';
      subscription.userTyping(typing)
    })

    $('#new_room_message').on('ajax:success', () => {
      this.$chatInput.val('');
      subscription.userTyping(false);
    });
  }

  initializeCable();
  initializeListeners(this.subscription);
}