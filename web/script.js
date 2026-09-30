// @ts-check
import init, { highlight } from "./typst_hl/typst_hl.js";

const input = document.querySelector("textarea");
if (!input) throw "input element not found";
const output = document.querySelector("output");
if (!output) throw "output element not found";

await init();
input.addEventListener("input", () => {
  output.innerHTML = highlight(input.value).html;
});

const copyButton = document.querySelector("button");
if (!copyButton) throw "copy button not found";
copyButton.addEventListener("click", () => {
  navigator.clipboard.writeText(highlight(input.value).ansi);
  copyButton.innerText = "Copied!";
  setTimeout(() => {
    copyButton.innerText = "Copy";
  }, 1000);
});
