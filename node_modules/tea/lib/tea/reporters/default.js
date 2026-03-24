var _ = require('../utils');

module.exports = function (logger, level, message, data, tokens) {
  var color = logger.levels.colors[level]
    , time = new Date(tokens.date);

  return _.colorize(time.getHours() + ':' + time.getMinutes() + ':' + time.getSeconds(), 'gray')
    + ' [' + tokens.namespace + '] '
    + _.colorize(_.padAfter(level, 10), color)
    + _.colorize(message, 'gray')
    + '\n';
};
