import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form", "list", "amount", "symbol","number", "submit" ]

  update() {
  const url = `${this.formTarget.action}?amount=${this.amountTarget.value}&symbol=${this.symbolTarget.value}`
  fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.listTarget.outerHTML = data;
    })
  }
}
