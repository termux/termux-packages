var folio = require('folio')
  , path = require('path')
  , fs = require('fs');


var drip = new folio.Glossary([
    path.join(__dirname, '..', 'lib', 'drip.js')
  ], {
    prefix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'prefix.js'), 'utf8'),
    suffix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'suffix.js'), 'utf8')
  });

drip.compile(function (err, source) {
  var copyright = fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'copyright.js'));
  fs.writeFileSync(path.join(__dirname, '..', 'dist', 'drip.js'), copyright + '\n' + source);
  console.log('Build successful: ' + '\tdrip.js');
});

var drip_min = new folio.Glossary([
    path.join(__dirname, '..', 'lib', 'drip.js')
  ], {
    minify: true,
    prefix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'prefix.js'), 'utf8'),
    suffix: fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'suffix.js'), 'utf8')
  });

drip_min.compile(function (err, source) {
  var copyright = fs.readFileSync(path.join(__dirname, '..', 'lib', 'browser', 'copyright.js'));
  fs.writeFileSync(path.join(__dirname, '..', 'dist', 'drip.min.js'), copyright + '\n' + source);
  console.log('Build successful: ' + '\tdrip.min.js');
});
