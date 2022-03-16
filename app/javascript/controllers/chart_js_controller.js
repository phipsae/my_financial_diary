import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["buttonPie", "buttonLine", "line", "pie"]
  static classes = ["hidden", "chart-btn", "chart-btn-active"]

  hiddenPie() {
    this.pieTarget.classList.add(this.hiddenClass)
    this.lineTarget.classList.remove(this.hiddenClass)
    this.buttonLineTarget.classList.add("chart-btn-active")
    this.buttonLineTarget.classList.remove("chart-btn")
    this.buttonPieTarget.classList.remove("chart-btn-active")
    this.buttonPieTarget.classList.add("chart-btn")
    // this.pieTarget.setAttribute("hidden", "")
  }

  hiddenLine(){
    this.lineTarget.classList.add(this.hiddenClass)
    this.pieTarget.classList.remove(this.hiddenClass)
    this.buttonPieTarget.classList.add("chart-btn-active")
    this.buttonPieTarget.classList.remove("chart-btn")
    this.buttonLineTarget.classList.remove("chart-btn-active")
    this.buttonLineTarget.classList.add("chart-btn")
  }
}
