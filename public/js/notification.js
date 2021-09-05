
document.querySelectorAll('.notification')
  .forEach(elm => {
    elm.addEventListener('click', markRead)
  })

function markRead(elm) {
  //elm.preventDefault()
  const notification_id = elm.target.dataset.id
  const url = elm.target.dataset.href
  fetch(`/notifications/read?notification_id=${notification_id}`)
    .then(res => res.json())
    .then(data => {
      location.href = url
    })
    .catch(err => console.error(err))
}
