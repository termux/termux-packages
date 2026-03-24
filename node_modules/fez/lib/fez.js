/*!
 * fez
 * Copyright(c) 2011 Jake Luer <@jakeluer>
 * MIT Licensed
 */

var stylus = require('stylus')
  , nib = require('nib');

exports = module.exports = plugin;

exports.path = __dirname;

exports.version = '0.0.3';

function plugin() {
  return function (style) {
    style.include(__dirname);
  };
}
