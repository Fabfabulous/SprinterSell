// app/javascript/controllers/class_modifier_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["myDiv"]

  connect() {
    this.updateClass();
  }

  updateClass() {

    if (company.status === 0) {
      this.myDivTarget.classList.add("vl-prospect");
    } else if (company.status === 1) {
      this.myDivTarget.classList.add("vl-client");
    } else (company.status === 2) {
      this.myDivTarget.classList.add("vl-client-to-visit");
    }
  }
}
