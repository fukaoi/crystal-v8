let To = require('/home/t/Work/crystal-v8/spec/support/to_require.js')

let main = function (res) {
  return `main: ${res}`
}
console.log(To);
main(To.multipli(10));