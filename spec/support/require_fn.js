let obj = require('./fn.js')

let main = function (fn) {
  return `main: ${fn()}`
}

main(obj.demo('require demo'))