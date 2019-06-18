const initializeApp = function(roomId) {
  const initializeCable = function() {
    this.subscription = App.cable.subscriptions.create('AppChannel', {
        received: function(data) {
          console.log(data)
        }
      }
    );
  }

  initializeCable();
}