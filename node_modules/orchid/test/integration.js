var chai = require('chai')
  , should = chai.should()
  , orchid = require('..');

describe('integration', function () {
  var serv = new orchid.Server();

  before(function (done) {
    serv.listen(4567, done);
  });

  after(function (done) {
    serv.close(done);
  });

  describe('single client connections', function () {
    var client
      , client2;

    it('should allow a client to connect', function (done) {
      client = new orchid.Client('ws://localhost:4567');
      client.once('open', function () {
        done();
      });
    });

    it('should allow a second client to connect', function (done) {
      client2 = new orchid.Client('ws://localhost:4567');
      client2.once('open', function () {
        done();
      });
    });

    it('should allow for events to be emitted accross the wire', function (done) {
      client.on([ 'hello', 'universe' ], function (err, res) {
        should.not.exist(err);
        res.should.eql({ hello: 'world' });
        done();
      });

      client2.emit([ 'hello', 'universe' ], null, { hello: 'world' });
    });

    it('should support RPC accross the wire', function (done) {
      client.on([ 'hello', 'rpc' ], function (err, res, cb) {
        should.not.exist(err);
        res.should.eql({ hello: 'universe' });
        cb('testing');
      });

      client2.emit([ 'hello', 'rpc' ], null, { hello: 'universe'}, function (res) {
        res.should.equal('testing');
        done();
      });
    });

    it('should allow a client to disconnect', function (done) {
      var i = 1;
      function after () {
        --i || done();
      }
      client.on('close', after);
      client2.on('close', after);
      client.close();
      client2.close();
    });
  });
});
