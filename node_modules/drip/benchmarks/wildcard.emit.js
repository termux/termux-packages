
var EE = require('events').EventEmitter
  , ee = new EE();

var drip = require('../lib/drip')
  , drop = new drip({ wildcard: true });

var EE2 = require('eventemitter2').EventEmitter2
  , ee2 = new EE2({ wildcard: true });

// warm up
bench('nodejs native events', function (next) {
  ee.on('test1', function () { 1==1; });
  ee.emit('test1');
  ee.removeAllListeners('test1');
  next();
});

bench('drip emit: single events', function (next) {
  drop.on('foo', function () { 1==1; });
  drop.emit('foo');
  drop.removeAllListeners('foo');
  next();
});

bench('eventemitter2 emit: single events', function (next) {
  ee2.on('foo', function () { 1==1; });
  ee2.emit('foo');
  ee2.removeAllListeners('foo');
  next();
});

bench('drip emit: namespace events', function (next) {
  drop.on('foo:bar', function () { 1==1; });
  drop.emit('foo:bar');
  drop.off('foo:bar');
  next();
});

bench('eventemitter2 emit: namespaced events', function (next) {
  ee2.on('foo.bar', function () { 1==1; });
  ee2.emit('foo.bar');
  ee2.removeAllListeners('foo.bar');
  next();
});

bench('drip emit: wildcarded events', function (next) {
  drop.on('foo:*', function () { 1==1; });
  drop.emit('foo:bar');
  drop.off('foo:*');
  next();
});

bench('eventemitter2 emit: wildcarded events', function (next) {
  ee2.on('foo.*', function () { 1==1; });
  ee2.emit('foo.bar');
  ee2.removeAllListeners('foo.*');
  next();
});

bench('drip emit: nested wildcarded events', function (next) {
  drop.on('foo:*:bar', function () { 1==1; });
  drop.emit('foo:drip:bar');
  drop.off('foo:*:bar');
  next();
});

bench('eventemitter2 emit: nested wildcarded events', function (next) {
  ee2.on('foo.*.bar', function () { 1==1; });
  ee2.emit('foo.ee2.bar');
  ee2.removeAllListeners('foo.*.bar');
  next();
});