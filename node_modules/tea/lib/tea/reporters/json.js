module.exports = function (logger, level, message, data, tokens) {
  var res = {};

  res.level = logger.levels.levels[level];
  res.levelStr = level;
  res.namespace = logger.namespace;

  res.message = message;
  res.data = data;
  res.tokens = tokens;

  return JSON.stringify(res) + '\n';
};
