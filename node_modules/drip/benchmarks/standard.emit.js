
var EE = require('events').EventEmitter
  , ee = new EE();

var EE2 = require('eventemitter2').EventEmitter2
  , ee2 = new EE2();

var drip = require('../lib/drip')
  , drop = new drip();

bench('nodejs native events', function (next) {
  ee.on('test1', function () { 1==1; });
  ee.emit('test1');
  ee.removeAllListeners('test1');
  next();
});

bench('eventemitter2 standard events', function (next) {
  ee2.on('test2', function () { 1==1; });
  ee2.emit('test2');
  ee2.removeAllListeners('test2');
  next();
});

bench('drip standard events', function (next) {
  drop.on('test3', function () { 1==1; });
  drop.emit('test3');
  drop.removeAllListeners('test3');
  next();
});