import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form", "list", "amount", "symbol", "submit" ]

  update() {
    const url = `https://cors-anywhere.herokuapp.com/https://pro-api.coinmarketcap.com/v2/tools/price-conversion?amount=10&symbol=BTC&CMC_PRO_API_KEY=be03173a-5462-4f4c-8b5b-bb204ae405f5`
    fetch(url, { headers: { 'Accept': 'application/json' } })
      .then(response => response.text())
      .then((data) => {
        console.log(data);
      })
  }
}
