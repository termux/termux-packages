var Oath = require('oath')
  , fs = require('fs')
  , path = require('path')
  , dox = require('dox')
  , _ = require('../utils');

module.exports = function (project, config) {
  var promise = new Oath()
    , files = config.files
    , dataDir = project.config.dataDir
    , outDir = project.config.outDir;

  doSeries(files, function (file, index, next) {
    var filename = path.resolve(dataDir, file.file);
    _.exists(filename, function (exist) {
      if (!exist) return next();
      var comments = dox.parseComments(fs.readFileSync(filename, 'utf8'), { raw: true })
        , name = file.name
        , outPath = outDir + '/code/' + name + '.html'
        , href = path.dirname(outPath).replace(outDir, '') + '/' + name + '.html'
        , defaults = {
              title: ''
            , template: 'code'
            , 'render-file': true
          }

      comments.forEach(function (comment) {
        if (comment.description) {
          comment.description.full = project.parseMarkdown(comment.description.full);
          comment.description.summary = project.parseMarkdown(comment.description.summary);
          comment.description.body = project.parseMarkdown(comment.description.body);
        }
      });

      defaults = _.defaults(file, defaults);
      var result = {
          title: file.title
        , description: project.parseMarkdown(file.description)
        , template: 'code'
        , outPath: outPath
        , href: href
        , prepared: comments
      };

      result = _.merge(defaults, result);
      project.emit([ 'register', 'file' ], result);
      project.emit([ 'register', 'group' ], 'code', result);
      next();
    });
  }, function () {
    promise.resolve({ name: 'code' });
  });

  return promise.promise;
};

function doSeries (arr, iterator, done) {
  var len = arr.length
    , i = 0;
  done = done || function () {};
  function iterate () {
    function cb() {
      if (++i == len) return done();
      iterate();
    };
    iterator(arr[i], i, cb);
  };
  iterate();
}
