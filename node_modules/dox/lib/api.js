
module.exports = function(comments){
  var buf = [];

  comments.forEach(function(comment){
    if (comment.isPrivate) return;
    if (comment.ignore) return;
    var ctx = comment.ctx;
    var desc = comment.description;
    if (!ctx) return;
    if (~desc.full.indexOf('Module dependencies')) return;
    if (!ctx.string.indexOf('module.exports')) return;
    buf.push('### ' + context(comment));
    buf.push('');
    buf.push(desc.full.trim().replace(/^/gm, '  '));
    buf.push('');
  });

  return buf.join('\n');
};

function context(comment) {
  var ctx = comment.ctx;
  var tags = comment.tags;
  switch (ctx.type) {
    case 'method':
      return (ctx.cons || ctx.receiver) + '#' + ctx.name + '(' + params(tags) + ')';
    default:
      return ctx.string;
  }
}

function params(tags) {
  return tags.filter(function(tag){
    return tag.type == 'param';
  }).map(function(param){
    return param.name + ':' + param.types.join('|');
  }).join(', ');
}