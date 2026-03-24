var fs = require('fs')
  , path = require('path');

var exports = module.exports = {};

fs.readdirSync(__dirname + '/transports').forEach(function (filename) {
  if (!/\.js$/.test(filename)) return;
  var name = path.basename(filename, '.js');
  function load () {
    return require('./transports/' + name);
  }
  Object.defineProperty(exports, name, { get: load });
});
