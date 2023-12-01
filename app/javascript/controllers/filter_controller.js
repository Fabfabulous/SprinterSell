import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit"]

  connect() {
  }

  getData(event){
    // event.preventDefault();
    // if (this.submitTarget.value === "Filter") {
    //   this.submitTarget.classList.add("bg-success")
    //   this.submitTarget.value = "Reset"
    // } else {
    //   this.submitTarget.classList.add("bg-primary")
    //   this.submitTarget.value = "Filter"
    // }
  }
}
