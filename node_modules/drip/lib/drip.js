/*!
 * drip - Node.js event emitter.
 * Copyright(c) 2011 Jake Luer <jake@alogicalparadox.com>
 * MIT Licensed
 */

/*!
 * primary module export
 */

var exports = module.exports = Drip;

/*!
 * version export
 */

exports.version = '0.2.4';

/**
 * # Drip#constructor
 *
 * Create new instance of drip. Can also be easily
 * be used as the basis for other objects.
 *
 *      // for normal events
 *      var drop = new Drip();
 *
 *      // for namespaced/wildcarded events
 *      var drop = new Drip({ wildcard: true });
 *
 * Wildcards and namespacing are off by default. By sending
 * the `wildcard` option as `true`, drip will enable both
 * wildcards and namespacing.
 *
 * ### Options
 *
 * * _delimeter_ {String} defaults to `:`
 * * _wildcard_ {Boolean} defaults to false
 *
 * @name constructor
 * @param {Object} options
 * @api public
 */
function Drip (opts) {
  if (opts) {
    this._drip = {};
    this._drip.delimeter = opts.delimeter || ':';
    this._drip.wildcard = opts.wildcard || (opts.delimeter ? true : false);
  }
}

/**
 * # .on(event, callback)
 *
 * Bind a `callback` function to all emits of `event`.
 * Wildcards `*`, will be executed for every event. At
 * that heirarchy.
 *
 *      // normal events
 *      drop.on('foo', callback);
 *
 *      // namespaced events as string
 *      drop.on('foo:bar', callback);
 *
 *      // namespaced events as array
 *      drop.on(['foo', 'bar', '*', 'fu'], callback);
 *
 * An array can be passed for event when namespacing is enabled
 * if that is your preference.
 *
 * @name on
 * @param {String|Array} event
 * @param {Function} callback
 * @api public
 */

Drip.prototype.on = function (ev, fn) {

  if (!this._drip || (this._drip && !this._drip.wildcard)) {
    var map = this._events || (this._events = {});

    if (!map[ev]) {
      map[ev] = fn;
    } else if ('function' === typeof map[ev]) {
      map[ev] = [ map[ev], fn ];
    } else {
      map[ev].push(fn);
    }

  } else if (this._drip && this._drip.wildcard) {
    var evs = Array.isArray(ev) ? ev : ev.split(this._drip.delimeter)
      , store = this._events || (this._events = {});

    var traverse = function (events, map) {
      var event = events.shift();
      map[event] = map[event] || {};

      if (events.length) {
        traverse(events, map[event]);
      } else {

        if (!map[event]._) {
          map[event]._= fn;
        } else if ('function' === typeof map[event]._) {
          map[event]._ = [ map[event]._, fn ];
        } else {
          map[event]._.push(fn);
        }

      }
    };

    traverse(evs, store);
  }

  return this;
};

/**
 * # .many(event, ttl, callback)
 *
 * Bind a `callback` function to count(`ttl`) emits of `event`.
 *
 *      // 3 times then auto turn off callback
 *      drop.many('event', 3, callback)
 *
 * @name many
 * @param {String|Array} event
 * @param {Integer} TTL Times to listen
 * @param {Function} callback
 * @api public
 */

Drip.prototype.many = function (ev, times, fn) {
  var self = this;

  var wrap = function() {
    if (--times === 0) {
      self.off(ev, wrap);
    }
    fn.apply(null, arguments);
  };

  this.on(ev, wrap);
  return this;
};

/**
 * # .once(event, callback)
 *
 * Bind a `callback` function to one emit of `event`.
 *
 *      drip.once('event', callback)
 *
 * @name once
 * @param {String|Array} event
 * @param {Function} callback
 * @api public
 */

Drip.prototype.once = function (ev, fn) {
  this.many(ev, 1, fn);
  return this;
};

/**
 * # .off([event], [callback])
 *
 * Unbind `callback` function from `event`. If no function
 * is provided will unbind all callbacks from `event`. If
 * no event is provided, event store will be purged.
 *
 *      drop.off('event', callback);
 *
 * @name off
 * @param {String|Array} event optional
 * @param {Function} callback optional
 * @api public
 */

Drip.prototype.off = function (ev, fn) {
  if (!this._events) return false;

  if (arguments.length === 0) {
    delete this._events;
    return true;
  }

  if (!this._drip || (this._drip && !this._drip.wildcard)) {
    if ('function' !== typeof fn) {
      this._events[ev] = null;
      return true;
    }

    var fns = this._events[ev];

    if (!fns) {
      return false;
    } else if ('function' === typeof fns && fns == fn) {
      this._events[ev] = null;
    } else if (Array.isArray(fns)) {
      for (var i = 0; i < fns.length; i++) {
        if (fns[i] == fn) fns.splice(i, 1);
      }

      if (fns.length === 0)
        this._events[ev] = null;

      if (fns.length == 1)
        this._events[ev] = fns[0];
    }
  } else {
    var evs = Array.isArray(ev) ? ev : ev.split(this._drip.delimeter);

    if (evs.length === 1) {
      if (this._events[ev]) this._events[ev]._ = null;
      return true;
    } else {
      var isEmpty = function (obj) {
        for (var name in obj) {
          if (obj[name] && name != '_') return false;
        }
        return true;
      };

      var clean = function (event) {
        if (fn && 'function' === typeof fn) {
          for (var i = 0; i < event._.length; i++) {
            if (fn == event._[i]) {
              event._.splice(i, 1);
            }
          }

          if (event._.length === 0)
            event._ = null;

          if (event._ && event._.length == 1)
            event._ = event._[0];
        } else {
          event._ = null;
        }

        if (!event._ && isEmpty(event))
          event = null;

        return event;
      };

      var traverse = function (events, map) {
        var event = events.shift();

        if (map[event] && map[event]._ && !events.length)
          map[event] = clean(map[event]);

        if (map[event] && events.length)
          map[event] = traverse(events, map[event]);

        if (!map[event]) {
          if (isEmpty(map)) map = null;
        }

        return map;
      };

      this._events = traverse(evs, this._events);
    }
  }

  return this;
};

/**
 * # .removeAllListeners([event], [callback])
 *
 * This is an alias for `.off()`.
 *
 * @name removeAllListeners
 * @see Drip.prototype.off
 * @api public
 */

Drip.prototype.removeAllListeners = Drip.prototype.off;

/**
 * # .emit(event, [args], [...])
 *
 * Trigger `event`, passing any arguments to callback functions.
 *
 *      // normal event
 *      drop.emit('event', arg, ...);
 *
 *      // namespaced as string
 *      drop.emit('foo:bar', arg, ...)
 *
 *      // namespaced as array
 *      drop.emit(['foo', 'bar'], arg, ...);
 *
 * @name emit
 * @param {String|Array} eventname
 * @param {String|Object} arguments multiple parameters to pass to callback functions
 * @api public
 */

Drip.prototype.emit = function () {
  var ev = arguments[0]
    , fns;

  if (!this._events) return false;

  if (!this._drip || (this._drip && !this._drip.wildcard)) {
    fns = this._events[ev];
  } else if (this._drip && this._drip.wildcard) {
    var evs = Array.isArray(ev) ? ev : ev.split(this._drip.delimeter)
      , fns = [];

    var addFns = function (funcs) {
      if ('function' == typeof funcs) {
        fns.push(funcs);
      } else {
        for (var i = 0; i < funcs.length; i++) {
          fns.push(funcs[i]);
        }
      }
    };

    var traverse = function (events, map) {
      var event = events.shift();

      if (map[event] && map[event]._ && !events.length)
        addFns(map[event]._);

      if (map['*'] && map['*']._ && !events.length)
        addFns(map['*']._);

      if (events.length) {
        if (map[event])
          traverse(events.slice(0), map[event]);

        if (map['*'])
          traverse(events.slice(0), map['*']);
      }
    };

    traverse(evs, this._events);
  }

  if ('function' === typeof fns) {
    switch (arguments.length) {
      case 1:
        fns.call(this);
        break;
      case 2:
        fns.call(this, arguments[1]);
        break;
      case 3:
        fns.call(this, arguments[1], arguments[2]);
        break;
      default:
        var l = arguments.length
          , _a = new Array(l - 1);

        for (var i = 1; i < l; i++) {
          _a[i - 1] = arguments[i];
        }

        fns.apply(this, _a);
        break;
    }
  } else if (Array.isArray(fns)) {
    var l = arguments.length
      , _a = new Array(l - 1);

    for (var i = 1; i < l; i++) {
      _a[i - 1] = arguments[i];
    }

    for (var i = 0; i < fns.length; ++i) {
      fns[i].apply(this, _a);
    }
  }

  return this;
};

/**
 * .proxyEvent(event, target);
 */

Drip.prototype.proxyEvent = function (ev, target, context) {
  context = context || target;
  this.on(ev, function () {
    var args = Array.prototype.slice.call(arguments)
      , event = [ ev ].concat(args);
    target.emit.apply(context, event);
  });
};


