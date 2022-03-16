import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form", "pricepoint", "query", "more", "submit" ]

  assetsUpdate() {
  const url = `${this.formTarget.action}?query=${this.queryTarget.value}&more=${this.moreTarget.value}`
  fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.pricepointTarget.outerHTML = data;
    })
  }

  dashboardUpdate() {
  const url = `${this.formTarget.action}?more=${this.moreTarget.value}`
  fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.pricepointTarget.outerHTML = data;
    })
  }
}
