var folio = require('folio')
  , path = require('path')
  , fs = require('fs');


var oath = new folio.glossary([
    path.join(__dirname, '..', 'lib', 'oath.js')
  ], {
    prefix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'prefix.js'), 'utf8'),
    suffix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'suffix.js'), 'utf8')
  });

oath.compile(function (err, source) {
  var copyright = fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'copyright.js'));
  fs.writeFileSync(path.join(__dirname, '..', 'dist', 'oath.js'), copyright + '\n' + source);
  console.log('Build successful: ' + '\toath.js');
});

var oath_min = new folio.glossary([
    path.join(__dirname, '..', 'lib', 'oath.js')
  ], {
    minify: true,
    prefix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'prefix.js'), 'utf8'),
    suffix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'suffix.js'), 'utf8')
  });

oath_min.compile(function (err, source) {
  var copyright = fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'copyright.js'));
  fs.writeFileSync(path.join(__dirname, '..', 'dist', 'oath.min.js'), copyright + '\n' + source);
  console.log('Build successful: ' + '\toath.min.js');
});