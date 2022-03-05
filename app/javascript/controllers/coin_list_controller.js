import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form", "list", "amount", "symbol","number", "submit" ]

  update() {
    event.preventDefault()
    const apiKey = process.env.COINMARKETCAP_API_KEY
    const url = `https://pro-api.coinmarketcap.com/v2/tools/price-conversion?amount=${this.amountTarget.value}&symbol=${this.symbolTarget.value}`
    fetch(url, { headers: {'X-CMC_PRO_API_KEY': apiKey, 'Accept': 'application/json' } })
      .then(response => response.json())
      .then((data) => {
        const cryptoValue = data.data[0]["quote"].USD.price
        this.listTarget.value = cryptoValue;
        this.numberTarget.value = this.amountTarget.value;
        console.log(cryptoValue)
      })
  }
}
