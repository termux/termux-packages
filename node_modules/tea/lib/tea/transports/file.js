var fs = require('fs')
  , join = require('path').join
  , Oath = require('oath')
  , reporters = require('../reporters')
  , utils = require('../utils');

module.exports = function (logger, spec) {
  var oath = new Oath()
    , stream;

  if (spec.stream) {
    stream = spec.stream;
    for (var name in logger.levels.levels)
      bind(logger, name, stream, spec.reporter || 'json');
    oath.resolve({ name: 'file' });
  } else if (spec.path) {
    utils.mkdir(spec.path, 0755, function (err) {
      if (err) oath.reject({ name: 'file', err: err });
      var filename = spec.filename || logger.namespace + '.log'
        , path = join(spec.path, filename);
      stream = fs.createWriteStream(path, { flags: 'a' } );
      for (var name in logger.levels.levels)
        bind(logger, name, stream, spec.reporter || 'json');
      oath.resolve({ name: 'file', path: path });
    });
  } else {
    oath.reject({
        name: 'file'
      , err: new Error('Tea file transport requires path or writeable stream.')
    });
  }

  return oath.promise;
};

function bind(logger, lvl, stream, reporter) {
  var stringify = reporters[reporter];
  logger.on([ 'log', '*', lvl ], function (msg, data, tokens) {
    var str = stringify(logger, lvl, msg, data, tokens);
    stream.write(str);
  });
}
