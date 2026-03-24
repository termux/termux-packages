var should = require('chai').should()
  , orchid = require('..');

describe('server', function () {

  it('should have a version', function () {
    orchid.version.should.match(/^\d+\.\d+\.\d+$/);
  });

  it('should be a wildcarded event emitter', function (done) {
    var serv = new orchid.Server()
      , c = 0;

    function after (d) {
      c++;
      d.should.equal(c);
      if (c == 2) done();
    };

    serv.on([ 'hello', '*' ], after);
    serv.emit('hello::universe', 1);
    serv.emit('hello::world', 2);
  });

  describe('listinging / closing', function () {
    var serv = new orchid.Server();

    it('should listen on a port', function (done) {
      serv.listen(4567, done);
    });

    it('should emit connection event', function (done) {
      serv.once('connection', function () { done() });
      var client = new orchid.Client('ws://localhost:4567');
    });

    it('should close and trigger callback', function (done) {
      serv.close(done);
    });

    it('should emit listening event', function (done) {
      serv.once('listening', done);
      serv.listen(4567);
    });

    it('should emit close event', function (done) {
      serv.on('close', done);
      serv.close();
    });
  });


});
