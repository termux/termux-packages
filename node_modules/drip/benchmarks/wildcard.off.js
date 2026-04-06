var drip = require('../lib/drip')
  , drop = new drip({ wildcard: true });

var EE2 = require('eventemitter2').EventEmitter2
  , ee2 = new EE2({ wildcard: true });

bench('wc: remove listener: drip single', function (next) {
  drop.on('test', function () { 1 == 1; });
  drop.off('test');
  next();
});

bench('wc: remove listener: ee2 single', function (next) {
  ee2.on('test', function () { 1 == 1; });
  ee2.removeAllListeners('test');
  next();
});

bench('wc: remove listener: drip wildcard', function (next) {
  drop.on([ 'foo', 'bar' ], function () { 1 == 1; });
  drop.off('foo:bar');
  next();
});

bench('wc: remove listener: ee2 wildcard', function (next) {
  ee2.on([ 'foo', 'bar' ], function () { 1 == 1; });
  ee2.removeAllListeners('foo.bar');
  next();
});