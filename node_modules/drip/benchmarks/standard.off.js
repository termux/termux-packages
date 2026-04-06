var EE = require('events').EventEmitter
  , ee = new EE();

var EE2 = require('eventemitter2').EventEmitter2
  , ee2 = new EE2();

var drip = require('../lib/drip')
  , drop = new drip();

var noop = function () { 1 == 1 }
  , noop2 = function () { 2 == 2 };

bench('single listener off: nodejs native events', function (next) {
  ee.on('test1', noop);
  ee.removeListener('test1', noop);
  next();
});

bench('single listener off: event emitter 2', function (next) {
  ee2.on('test1', noop);
  ee2.off('test1', noop);
  next();
});

bench('single listener off: drip', function (next) {
  drop.on('test1', noop);
  drop.off('test1', noop);
  next();
});



bench('multiple listener off: nodejs native events', function (next) {
  ee.on('test1', noop);
  ee.on('test1', noop2);
  ee.removeListener('test1', noop);
  ee.removeListener('test1', noop2);
  next();
});

bench('multiple listener off: event emitter 2', function (next) {
  ee2.on('test1', noop);
  ee2.on('test1', noop2);
  ee2.off('test1', noop);
  ee2.off('test1', noop2);
  next();
});

bench('multiple listener off: drip', function (next) {
  drop.on('test1', noop);
  drop.on('test1', noop2);
  drop.off('test1', noop);
  drop.off('test1', noop2);
  next();
});