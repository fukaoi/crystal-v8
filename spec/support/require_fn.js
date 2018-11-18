let To = require('./to_require.js')

let main = function (res) {
  return `main: ${res}`
}

main(To.multipli(10));