
/*!
 * Quick implementation for console coloring.
 *
 * @api private
 */

[ 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'gray' ].forEach(function (color) {
  String.prototype.__defineGetter__(color, function () {
    var options = {
        'red': '\u001b[31m'
      , 'green': '\u001b[32m'
      , 'yellow': '\u001b[33m'
      , 'blue': '\u001b[34m'
      , 'magenta': '\u001b[35m'
      , 'cyan': '\u001b[36m'
      , 'gray': '\u001b[90m'
      , 'reset': '\u001b[0m'
    };
    return options[color] + this + options['reset'];
  });
});