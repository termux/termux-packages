var Oath = require('oath')
  , fs = require('fs')
  , path = require('path')
  , _ = require('../utils')
  , yaml = require('yaml');

module.exports = function (project, config) {
  var promise = new Oath()
    , dataDir = config.pages
    , outDir = project.config.outDir;

  getFiles(config.pages, function (err, results) {
    if (err) return promise.reject({ name: 'files', err: err });

    var fileNames = [];
    results.forEach(function (res) {
      var filename = path.basename(res).replace(path.extname(res), '');
      if (filename != 'index') filename = filename + '/index';

      var outPath = (path.dirname(res) + '/' + filename + '.html').replace(dataDir, outDir)
        , href = path.dirname(outPath).replace(outDir, '') + '/'
        , shortName = res.replace(dataDir, '')
        , template = outPath.replace(outDir, '').split('/')[1].split('.')[0]
        , group = (shortName.split('/').length == 2) ? 'root' : template , markdown = fs.readFileSync(res, 'utf8')
        , yml = markdown.match(/^-{3}((.|\n)*)-{3}/g)
        , defaults = {
              title: ''
            , template: template
            , 'render-file': true
          }

      if (yml) {
        var props = yaml.eval(yml[0]);
        markdown = markdown.replace(/^-{3}((.|\n)*)-{3}/g, '');
        defaults = _.defaults(props, defaults);
      }

      var result = {
          inPath: res
        , inFile: shortName
        , outPath: outPath
        , href: href
        , prepared: project.parseMarkdown(markdown)
      };

      fileNames.push(shortName);
      result = _.merge(defaults, result);
      if (result['render-file'])
        project.emit([ 'register', 'file' ], result);

      project.emit([ 'register', 'group' ], group, result);
    });

    promise.progress({
        message: 'Found all markdown files.'
      , array: fileNames
    });

    promise.resolve({ name: 'pages' });
  });

  return promise.promise;
};

function getFiles (base, next) {
  var results = [];
  fs.readdir(base, function(err, list) {
    if (err) return next(err);
    var pending = list.length;
    if (!pending) next(null, []);
    list.forEach(function(file) {
      file = base + '/' + file;
      fs.stat(file, function(err, stat) {
        if (err) next(err);
        if (stat && stat.isDirectory()) {
          getFiles(file, function(err, res) {
            if (err) next(err);
            results = results.concat(res);
            if (!--pending) next(null, results);
          });
        } else {
          var ext = path.extname(file).toLowerCase();
          if (ext == '.md' || ext == '.markdown')
            results.push(file);
          if (!--pending) next(null, results);
        }
      });
    });
  });
}
