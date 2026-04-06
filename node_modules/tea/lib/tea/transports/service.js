var Oath = require('oath')
  , orchid = require('orchid')
  , reporters = require('../reporters');

module.exports = function (logger, spec) {
  var defer = new Oath()
    , client;

  if (!spec) {
    defer.reject({ name: 'service' });
  } else {
    client = new orchid.Client(spec);
    client.on('open', function () {
      for (var name in logger.levels.levels) {
        bind(logger, name, client);
      }
      defer.resolve({ name: 'service' });
    });
  }

  return defer.promise;
};

function bind (logger, lvl, client) {
  var json = reporters['json'];
  logger.on([ 'log', '*', lvl ], function (msg, data, tokens) {
    var obj = JSON.parse(json(logger, lvl, msg, data, tokens));
    client.emit([ 'tea', 'log' ], obj);
  });
};
