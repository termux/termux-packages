var fs = require('fs')
  , path = require('path')
  , _utils = {};

var exports = module.exports = {};

fs.readdirSync(__dirname + '/utils').forEach(function(filename){
  if (!/\.js$/.test(filename)) return;
  var name = path.basename(filename, '.js');
  Object.defineProperty(_utils, name,
    { get: function () {
        return require('./utils/' + name);
      }
    , enumerable: true
  });
});

for (var exp in _utils) {
  var util = _utils[exp];
  exports = _utils.object.merge(exports, util);
}