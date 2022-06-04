import {mountSparkline, sparkline} from "./sparkline"

export function Hook() {
  let Hooks = {}

  Hooks.Sparkline = {
    mounted() {
      mountSparkline(this.el.id);
      sparkline(this.el.id);
    }
  }

  Hooks.Price = {
    updated(test) {
      const element = this.el;
      const id = this.el.id;
      const updatedValue = this.el.textContent;

      // Update the sparkline
      sparkline(`chart${id}`, updatedValue);

      // Update the flash
      element.classList.remove("highlight");
      element.offsetWidth; // reset animation if called quickly
      element.classList.add("highlight");
    }
  }

  return Hooks
}
