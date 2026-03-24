var should = require('chai').should()
  , rimraf = require('rimraf')
  , path = require('path')
  , fs = require('fs')
  , exists = path.existsSync || fs.existsSync;

var codex = require('..');

function onError (e) {
  should.not.exist(e);
  true.should.be.false;
}

describe('Project', function () {

  var project = codex({
      locals: {
        title: 'Hello Universe'
      }
    , inDir: path.join(__dirname, 'fixture')
  });

  var out = path.join(__dirname, 'fixture', 'out')
    , temp = path.join(__dirname, 'fixture', 'template');

  beforeEach(function () {
    project.removeAllListeners('error');
  });

  after(function (done) {
    rimraf(out, done);
  });

  it('should have a version', function () {
    codex.version.should.match(/\d+\.\d+\.\d+$/);
  });

  it('should correctly initialize', function () {
    project.config.inDir.should.be.ok;
  });

  it('should correctly setup folders', function (done) {
    project.once('error', onError);
    project.assertFolders().then(
        function () {
          project.config.outDir.should.equal(out);
          project.config.templateDir.should.equal(temp);
          exists(out).should.be.true;
          done();
        }
      , onError
    );
  });

  it('should correctly build', function (done) {
    project.on('error', onError);
    project.build(function () {
      exists(out).should.be.true;
      exists(path.join(out, 'public/css/main.css')).should.be.true;
      done();
    });
  });
});
