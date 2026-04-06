/*!
 * oath - Node.js event emitter.
 * Copyright(c) 2011 Jake Luer <jake@alogicalparadox.com>
 * MIT Licensed
 */

!function (name, definition) {
  if (typeof module != 'undefined') module.exports = definition();
  else if (typeof define == 'function' && typeof define.amd  == 'object') define(definition);
  else this[name] = definition();
}('oath', function () {
  if (!module) {
    var module = {};
  }

/*!
 * Oath - Node.js / browser event emitter.
 * Copyright(c) 2011 Jake Luer <jake@alogicalparadox.com>
 * MIT Licensed
 */

var exports = module.exports = Oath;


/*!
 * oath version
 */
exports.version = '0.2.3';

/**
 * # Oath constructor
 *
 * Create a new promise.
 *
 * #### Options
 *
 * * parent - used internally for chaining
 * * context - object to set as `this` in callbacks
 *
 * You can use `Oath` within single functions
 *
 *      // assignment style
 *      var promise = new oath();
 *      promise.then(successFn, errorFn);
 *      myAsycFunction(function(err, result) {
 *        if (err) promise.reject(err);
 *        promise.resolve(result);
 *      });
 *
 * Or return them to ease chaining of callbacks
 *
 *      // return style
 *      function doSomething(data) {
 *        var promise = new oath();
 *        // async stuff here
 *        // promise should be returned immediately
 *        return promise;
 *      }
 *
 *      doSomething(data).then(successFn, errorFn);
 *
 * @name constructor
 * @param {Object} options
 * @api public
 */

function Oath (options) {
  options = options || {};

  this._pending = {};
  this._oath = {
      complete: false
    , context: options.context || this
  };

  var self = this;
  this.promise = {
      then: function (success, failure, progress) {
        if (success) self._register('resolve', success);
        if (failure) self._register('reject', failure);
        if (progress) self._register('progress', progress);
        if (self._oath.complete) self._traverse();
        return this;
      }
    , onprogress: function (fn) {
        self._register('progress', fn);
        return this;
      }
    , node: function (callback) {
        this.then(
            function (d) { callback(null, d); }
          , function (e) { callback(e); }
        );
        return this;
      }
  };
}

/**
 * # Oath.resolve(result)
 *
 * Emits completion event to execute `success` chain of functions.
 *
 *        // When async work is complete
 *        promise.resolve(my_data_obj);
 *
 * @name Oath.resolve
 * @param {Object} result
 * @api public
 */

Oath.prototype.resolve = function (result) {
  this._fulfill('resolve', result);
};

/**
 * # Oath.reject(result)
 *
 * Emit completion event to execute `failure` chain of functions.
 *
 *        // When async work errors
 *        promise.reject(my_error_obj);
 *
 * @name Oath.reject
 * @param {Object} result
 * @api public
 */

Oath.prototype.reject = function (result) {
  this._fulfill('reject', result);
};

/**
 * # Oath.progress(current, max)
 *
 * Emits the current progress to the the progress stack of functions.
 *
 * @name Oath.progress
 * @param {Object} result
 * @api public
 */

Oath.prototype.progress = function (result) {
  var map = this._pending['progress'];

  if (!map) return false;
  else {
    for (var i = 0; i < map.length; i++) {
      map[i](result);
    }
  }
};

/**
 * # Oath.node(err, [...])
 *
 * Provides a node-able function...
 * Works, provided the expectation is that
 * if there was an error, it will be returned
 * as the first argument.
 *
 *    var oath = new Oath();
 *    fs.mkdir(dir, oath.node());
 *
 * @name Oath.node
 * @return {Function} expection function (err, data) { ...
 */

Oath.prototype.node = function () {
  var self = this;
  return function () {
    if (arguments[0]) return self.reject(arguments[0]);
    var args = Array.prototype.slice.call(arguments, 1, arguments.length)
    self.resolve.apply(self, args);
  }
};

/**
 * # .then([success], [failure])
 *
 * Chainable function for promise observers to queue result functions.
 *
 *      doSomething(my_data)
 *        .then(successFn1, failureFn1)
 *        .then(successFn2, failureFn2)
 *
 * @name then
 * @param {Function} success will execute on `resolve`
 * @param {Function} failure will execute on `reject` (optional)
 * @api public
 */

//Oath.prototype.then =

Oath.prototype._register = function (type, fn) {
  var context = this._oath.context
    , map = this._pending[type]
    , cb;

  // For sync functions
  if (fn.length < 2) {
    cb = function (result) {
      return fn.call(context, result);
    };

  // For async functions
  } else if (fn.length == 2) {
    cb = function (result, next) {
      fn.call(context, result, next);
    };

  // WTF?
  } else {
    throw new Error('Oath: Invalid function registered - to many parameters.');
  }

  if (!map) this._pending[type] = [ cb ];
  else map.push(cb);
};

/*!
 * # ._fulfill(type, result)
 *
 * Check to see if the results have been posted,
 * and if not, store results and start callback chain.
 *
 * @name fulfill
 * @param {String} type
 * @param {Object} result
 * @api private
 */

Oath.prototype._fulfill = function (type, result) {
  if (this._oath.complete) return false;
  this._oath.complete = {
      type: type
    , result: result
  };
  this._traverse();
};

/*!
 * # ._traverse()
 *
 * Iterate through the callback stack and execute
 * functions serially. Provide next helper to async
 * functions and handle result reassignment.
 *
 * @name traverse
 * @api private
 */

Oath.prototype._traverse = function () {
  var self = this
    , context = this._oath.context
    , type = this._oath.complete.type;

  if (!this._pending[type]) {
    return false;
  }

  var iterate = function () {
    var fn = self._pending[type].shift()
      , result = self._oath.complete.result;
    if (fn.length < 2) {
      var res = fn(result);
      if (res) self._oath.complete.result = res;
      if (self._pending[type].length) iterate();
    } else {
      var next = function (res) {
        if (res) self._oath.complete.result = res;
        if (self._pending[type].length) iterate();
      }
      fn(result, next);
    }
  }

  iterate();
};


  return exports;
});