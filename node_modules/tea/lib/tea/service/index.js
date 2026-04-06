var orchid = require('orchid')
  , Service = require('./service');

module.exports = function (port, options, done) {
  if ('function' === typeof options) {
    done = options;
    options = {};
  }

  var server = new orchid.Server();

  server.listen(port, function () {
    var service = new Service('ws://localhost:' + port, options);

    service.on(['service', 'shutdown' ], function () {
      service.close();
      server.close(function () {
        process.exit();
      });
    });

    service.on('open', function () {
      done(server, service);
    });
  });
};
