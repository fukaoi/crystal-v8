import To, { multipli } from './support/to_require.js';

let main = function (res) {
  return `main: ${res}`
}
console.log(To);
main(multipli(10));