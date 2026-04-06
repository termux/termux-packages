/*!
 * Orchid - Server
 * Copyright (c) 2012 Jake Luer <jake@qualiancy.com>
 * MIT Licensed
 */

/*!
 * Module dependancies
 */

var util = require('util')
  , Drip = require('drip')
  , WebSocket = require('ws')
  , _ = require('./utils');

/*!
 * Main export
 */

module.exports = Client;

/**
 * Client (constructor)
 *
 * Creates a new websocket client and connects to address
 *
 * @param {String} address ws:// __
 * @param {Object} options
 * @api public
 */

function Client (address, options) {
  Drip.call(this, { delimeter: '::' });
  options = options || {};

  if (this.events) bindEvents.call(this, this.events);
  if (options.events) bindEvents.call(this, options.events);

  this.address = address;
  this.options = options;
  this.rpc = {};
  this._queue = [];
  this.retryCount = 0;

  createWs.call(this);
  this.initialize(options);
}

Client.extend = _.extend;

util.inherits(Client, Drip);

Client.prototype.initialize = function () {};

Client.prototype._emit = function () {
  Drip.prototype.emit.apply(this, arguments);
};

Client.prototype.emit = function () {
  if (this._ws.readyState != 1) {
    this._queue.push(arguments);
    return;
  }

  var event = arguments[0]
    , args = Array.prototype.slice.call(arguments, 1)
    , len = args.length;

  if ('function' === typeof args[len - 1]) {
    var cb = args.splice(len - 1, 1)
      , id = makeid();
    this.rpc[id] = cb[0];
    this._ws.send(this.frame('request', { event: event, id: id, args: args }));
  } else {
    this._ws.send(this.frame('event', { event: event, args: args }));
  }
};

Client.prototype.close = function () {
  this._ws.close()
};

Client.prototype.frame = function (cmd, data) {
  return JSON.stringify({
      command: cmd
    , data: data
  });
};

function createWs () {
  var address = this.address;
  delete this._ws;
  this._ws = new WebSocket(address);
  this._ws.on('open', connectHandler.bind(this));
  this._ws.on('close', disconnectHandler.bind(this));
  this._ws.on('message', messageHandler.bind(this));
  this._ws.on('error', errorHandler.bind(this));
}

function bindEvents (events) {
  var self = this;

  var mapFn = function (ev, name) {
    var fn = self[name];
    if (fn && 'function' === typeof fn) {
      self.on(ev, function () {
        fn.apply(self, arguments);
      });
    }
  };

  for (var ev in events) {
    var fns = events[ev];
    if (Array.isArray(fns)) {
      for (var i in fns) {
        mapFn(ev, fns[i]);
      }
    } else {
      mapFn(ev, fns);
    }
  }
}

function connectHandler () {
  var self = this;
  this._emit('open');
  this._queue.forEach(function (args) {
    self.emit.apply(self, args);
  });
}

function messageHandler (data, flags) {
  var self = this
    , inc = JSON.parse(data);
  switch (inc.command) {
    case 'event':
      var event = Array.isArray(inc.data.event) ? inc.data.event : inc.data.event.split(this._drip.delimiter)
        , args = [event].concat(inc.data.args || {});
      this._emit.apply(this, args);
      break;
    case 'request':
      var event = Array.isArray(inc.data.event) ? inc.data.event : inc.data.event.split(this._drip.delimiter)
        , id = inc.data.id
        , args = [event].concat(inc.data.args || {});
      args.push(function () {
        var res = Array.prototype.slice.call(arguments, 0)
          , response = self.frame('response', { id: id, args: res });
        self._ws.send(response);
      });
      this._emit.apply(this, args);
      break;
    case 'response':
      var id = inc.data.id
        , res = inc.data.args
        , cb = this.rpc[id];
      if (cb) {
        cb.apply(this, res);
      }
      break;
  };
}

function disconnectHandler () {
  this._emit('close');
}

function errorHandler (err) {
  if (err.code == 'ECONNREFUSED') {
    retryHandler.call(this);
  }
  this._emit('error');
}

function retryHandler() {
  var self = this;
  if (this.retryCount < 10) {
    this.retryCount++;
    setTimeout(function () {
      createWs.call(self);
    }, 100);
  }
}

function makeid() {
  var text = ""
    , possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  for( var i=0; i < 10; i++ )
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  return text;
}
