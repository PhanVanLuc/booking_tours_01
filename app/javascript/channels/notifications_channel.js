import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    $("#notification-list").prepend(data.layout)
    document.querySelector("#notification-counter").innerHTML = ++(document.querySelector("#notification-counter").innerText)
    document.querySelectorAll('.notification')
      .forEach(elm => {
        elm.addEventListener('click', markRead)
      })
  }
});
