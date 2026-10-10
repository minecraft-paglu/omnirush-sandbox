import type { Action, InputFrame } from "./types";

const keys = new Set<string>();
const previousKeys = new Set<string>();
let sequence = 0;

const keyMap: Record<string, Action> = {
  j: "light", k: "heavy", l: "guard", " ": "jump", Shift: "dash", i: "throw", u: "ultimate",
  e: "form1", r: "form2", t: "form3", y: "form4", x: "form5",
};
const p2KeyMap: Record<string, Action> = {
  Numpad1: "light", Numpad2: "heavy", Numpad3: "guard", Numpad0: "jump", Enter: "dash", Decimal: "throw",
  Numpad4: "form1", Numpad5: "form2", Numpad6: "form3", Numpad7: "form4", Numpad8: "form5", Numpad9: "ultimate",
};

export function installKeyboard(): void {
  window.addEventListener("keydown", (event) => {
    if ([" ", "Shift", "ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(event.key)) event.preventDefault();
    keys.add(event.key);
  });
  window.addEventListener("keyup", (event) => keys.delete(event.key));
}

function frameFor(tick: number, p2: boolean): InputFrame {
  const moveKeys = p2 ? { up: "ArrowUp", down: "ArrowDown", left: "ArrowLeft", right: "ArrowRight" } : { up: "w", down: "s", left: "a", right: "d" };
  const move = { x: Number(keys.has(moveKeys.right)) - Number(keys.has(moveKeys.left)), y: Number(keys.has(moveKeys.up)) - Number(keys.has(moveKeys.down)) };
  const actionMap = p2 ? p2KeyMap : keyMap;
  const held: InputFrame["held"] = {};
  const pressed: InputFrame["pressed"] = {};
  for (const [key, action] of Object.entries(actionMap)) {
    const isHeld = keys.has(key);
    held[action] = isHeld;
    pressed[action] = isHeld && !previousKeys.has(key);
  }
  return { sequence: ++sequence, tick, move, held, pressed };
}

export function sampleInputs(tick: number): [InputFrame, InputFrame] {
  const result: [InputFrame, InputFrame] = [frameFor(tick, false), frameFor(tick, true)];
  previousKeys.clear();
  for (const key of keys) previousKeys.add(key);
  return result;
}
