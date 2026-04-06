var _ = require('../utils');

module.exports = function (logger, level, message, data, tokens) {
  var color = logger.levels.colors[level]
    , lvl = (level.length <= 5) ? level.toUpperCase() : level.substring(0, 4).toUpperCase();
  return _.highlight(logger.namespace, 'gray')  + ' ' + _.colorize(_.padAfter(lvl, 8), color)  + _.colorize(message, 'gray') + '\n';
};