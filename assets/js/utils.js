
export function fadingHook() {
  let Hooks = {}

  Hooks.Price = {
    updated() {
        let element = this.el;
        element.classList.remove("highlight");
        element.offsetWidth;
        element.classList.add("highlight");
    }
  }

  return Hooks
}
