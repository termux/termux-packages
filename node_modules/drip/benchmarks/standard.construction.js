var drip = require('../lib/drip');

var EE = require('events').EventEmitter;

var EE2 = require('eventemitter2').EventEmitter2;

bench('construction: drip on/off single', function (next) {
  var drop = new drip();
  drop.on('test', function () { 1 == 1; });
  drop.removeAllListeners('test');
  next();
});

bench('construction: ee on/off single', function (next) {
  var ee = new EE();
  ee.on('test', function () { 1 == 1; });
  ee.removeAllListeners('test');
  next();
});

bench('construction: ee2 on/off single', function (next) {
  var ee2 = new EE2();
  ee2.on('test', function () { 1 == 1; });
  ee2.removeAllListeners('test');
  next();
});