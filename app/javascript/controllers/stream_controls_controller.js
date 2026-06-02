import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  started(event) {
    this.flashButton(event.currentTarget, "Streaming")
  }

  stopped(event) {
    this.flashButton(event.currentTarget, "Stopped")
  }

  resetForm(event) {
    if (event.detail.success) {
      event.currentTarget.reset()
    }
  }

  flashButton(button, label) {
    const original = button.innerText
    button.innerText = label
    window.setTimeout(() => {
      button.innerText = original
    }, 1200)
  }
}

