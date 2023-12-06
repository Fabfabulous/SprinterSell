import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notes"
export default class extends Controller {
  static targets = ['helpButton', "note", "companyId"]
  connect() {
    console.log("coucou from notes");
  }
  
  rephrase() {
    event.preventDefault();
    const note = this.noteTarget.value;
    const companyId = this.companyIdTarget.value;

    fetch(`/notes/new?note=${note}&company_id=${companyId}`, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then((data) => {
        console.log(data);
        this.noteTarget.value = data;
      })
  }
}
