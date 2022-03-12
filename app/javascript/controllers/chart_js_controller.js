import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button", "line", "pie"]
  static classes = ["hidden"]

  hiddenPie() {
    this.pieTarget.classList.add(this.hiddenClass)
    this.lineTarget.classList.remove(this.hiddenClass)
    // this.pieTarget.setAttribute("hidden", "")
  }

  hiddenLine(){
    this.lineTarget.classList.add(this.hiddenClass)
    this.pieTarget.classList.remove(this.hiddenClass)
  }
}
