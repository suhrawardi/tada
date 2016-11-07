let List = {

  init(socket, element) { if (!element) { return }
    let listId = element.getAttribute("data-list-id")
    socket.connect()
    this.onReady(listId, socket)
  },

  onReady(listId, socket) {
    let itemContainer = document.getElementById("item-container")
    let itemInput = document.getElementById("item-input")
    let itemButton = document.getElementById("item-button")
    let listChannel = socket.channel("lists:" + listId)

    itemButton.addEventListener("click", e => {
      let payload = {body: itemInput.value}
      listChannel.push("new_item", payload)
                 .receive("error", e => console.log(e))
      itemInput.value = ""
    })

    listChannel.on("new_item", (resp) => {
      this.renderItem(itemContainer, resp)
    })

    listChannel.join()
      .receive("ok", resp => console.log("joined the todo list channel", resp))
      .receive("error", reason => console.log("failed to join", reason))
  },

  esc(str) {
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  renderItem(itemContainer, {list, body}) {
    let template = document.createElement("div")
    template.innerHTML = `<li>${this.esc(body)}</li>`
    itemContainer.appendChild(template)
    itemContainer.scrollTop = itemContainer.scrollHeight
  }
}

export default List
