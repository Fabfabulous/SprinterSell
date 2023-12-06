import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]

  connect() {
  }

  filter(event){
    const value = event.currentTarget.value
    fetch(`/search_company?query=${value}`)
    .then(response => response.json())
    .then(data => {
      this.listTarget.innerHTML= data.companies_partial
    })
  }
}
