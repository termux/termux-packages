/*!
 * Orchid - Server
 * Copyright (c) 2012 Jake Luer <jake@qualiancy.com>
 * MIT Licensed
 */

/*!
 * Module dependancies
 */

var util = require('util')
  , http = require('http')
  , Drip = require('drip')
  , WebSocketServer = require('ws').Server
  , _ = require('./client');

/*!
 * Main export
 */

module.exports = Server;

/**
 * Server (constructor)
 *
 * Creates a new Orchid server and mounts listeners
 *
 * @param {Object} options
 * @api public
 */

function Server(opts) {
  Drip.call(this, {
      wildcard: true
    , delimeter: '::'
  });

  this.clients = [];

  this._server = http.createServer();
  this._wss = new WebSocketServer({ server: this._server });
  this._wss.on('connection', connectHandler.bind(this));
}

Server.extend = _.extend;

util.inherits(Server, Drip);

Server.prototype.listen = function (port, cb) {
  var self = this;
  cb = cb || function () {};
  this._server.listen(port, function () {
    self.emit('listening');
    cb();
  });
};

Server.prototype.close = function (cb) {
  var self = this;
  cb = cb || function () {};
  this._server.once('close', function () {
    self.emit('close');
    cb();
  });
  this._wss.close();
  this._server.close();
};

function connectHandler (ws) {
  var self = this;

  ws.on('message', function (m) {
    for (var i = 0; i < self.clients.length; i++) {
      var client = self.clients[i];
      if (client) client.send(m);
    }
  });

  ws.on('close', function () {
    var i = self.clients.indexOf(ws);
    delete self.clients[i];
  });

  this.clients.push(ws);
  this.emit('connection', ws);
};
