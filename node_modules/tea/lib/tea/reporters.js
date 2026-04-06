var fs = require('fs')
  , path = require('path');

var exports = module.exports = {};

fs.readdirSync(__dirname + '/reporters').forEach(function (filename) {
  if (!/\.js$/.test(filename)) return;
  var name = path.basename(filename, '.js');
  function load () {
    return require('./reporters/' + name);
  }
  Object.defineProperty(exports, name, { get: load });
});
