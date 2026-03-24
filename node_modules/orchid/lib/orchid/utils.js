var utils = module.exports;

utils.merge = function(a, b){
  if (a && b) {
    for (var key in b) {
      a[key] = b[key];
    }
  }
  return a;
};

utils.defaults = function (a, b) {
  if (a && b) {
    for (var key in b) {
      if ('undefined' == typeof a[key]) a[key] = b[key];
    }
  }
  return a;
};

utils.extend = function (proto, klass) {
  var child = exports.inherits(this, proto, klass);
  child.extend = this.extend;
  return child;
};

utils.inherits = function (parent, proto, klass) {
  var child,
      noop = function () {};

  if (proto && proto.hasOwnProperty('constructor')) {
    child = proto.constructor;
  } else {
    child = function () { return parent.apply(this, arguments); };
  }

  exports.merge(child, parent);
  noop.prototype = parent.prototype;
  child.prototype = new noop();

  if (proto) exports.merge(child.prototype, proto);
  if (klass) exports.merge(child, klass);
  child.prototype.constructor = child;

  return child;
};
