

var utils = module.exports = {};

utils.colorize = function (str, color) {
  var options = {
      red:      '\u001b[31m'
    , green:    '\u001b[32m'
    , yellow:   '\u001b[33m'
    , blue:     '\u001b[34m'
    , magenta:  '\u001b[35m'
    , cyan:     '\u001b[36m'
    , gray:     '\u001b[90m'
    , reset:    '\u001b[0m'
  };
  return options[color] + str + options.reset;
};

utils.highlight = function (str, color) {
  var options = {
      red:      '\u001b[41m'
    , green:    '\u001b[42m'
    , yellow:   '\u001b[43m'
    , blue:     '\u001b[44m'
    , magenta:  '\u001b[45m'
    , cyan:     '\u001b[46m'
    , gray:     '\u001b[100m'
    , reset:    '\u001b[0m'
  };
  return options[color] + str + options.reset;
};

utils.padBefore = function (str, width) {
  return Array(width - str.length).join(' ') + str;
};

utils.padAfter = function (str, width) {
  return str + Array(width - str.length).join(' ');
};

utils.mkdir = function (_path, mode, callback) {
  var path = require('path')
    , fs = require('fs');

  if ('function' === typeof mode) {
    callback = mode;
    mode = 0755;
  }

  callback = callback || function () {};
  _path = path.resolve(_path);

  function _mkdir(p, next) {
    var _p = path.normalize(p).split('/');

    path.exists(p, function (exists) {
      if (!exists) {
        _mkdir(_p.slice(0, -1).join('/'), function (err) {
          if (err) next(err);
          fs.mkdir(p, mode, function () {
            next(null);
          });
        });
      } else {
        next(null);
      }
    });
  }

  _mkdir(_path, function(err) {
    if (err) callback(err);
    callback(null);
  });
};