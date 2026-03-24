var Oath = require('oath')
  , reporters = require('../reporters');

module.exports = function (logger, spec) {
  var oath = new Oath()
    , stream = process.stdout;

  spec = spec || {};

  for (var name in this.levels.levels) {
    bind(logger, name, stream, spec.reporter || 'default');
  }

  oath.resolve({ name: 'console' });
  return oath.promise;
};

function bind(logger, lvl, stream, reporter) {
  var stringify = reporters[reporter];
  logger.on([ 'log', '*', lvl ], function (msg, data, tokens) {
    var str = stringify(logger, lvl, msg, data, tokens);
    stream.write(str);
  });
}
