var should = require('chai').should()
  , WebSocket = require('ws')
  , Drip = require('drip')
  , orchid = require('..');

describe('client', function () {
  var Serv = new WebSocket.Server({ port: 4567 })
    , emitter = new Drip();

  before(function () {
    Serv.on('connection', function (sock) {
      sock.on('message', function (data, flags) {
        emitter.emit('event', data, flags);
        switch (data) {
          case 'trigger 1':
            sock.send(JSON.stringify({
                command: 'event'
              , data: {
                    event: [ 'hello', 'universe' ]
                  , args: [ { test: true } ]
                }
            }));
            break;
        };
      });
    });
  });

  after(function () {
    Serv.close();
  });

  it('should be a wildcarded event emitter', function (done) {
    var client = new orchid.Client('ws://localhost:4567')
      , c = 0;

    function after (d) {
      c++;
      d.should.equal(c);
      if (c == 2) done();
    };

    client.on([ 'hello', '*' ], after);
    client._emit('hello::universe', 1);
    client._emit('hello::world', 2);
  });

  it('should be able to emit events', function (done) {
    var client = new orchid.Client('ws://localhost:4567')

    emitter.once('event', function (data, flags) {
      var json = JSON.parse(data);
      json.should.eql({
          command: 'event'
        , data: {
              event: [ 'hello', 'universe' ]
            , args: [ { test: true } ]
          }
      });
      client.close();
      done();
    });

    client.emit([ 'hello', 'universe' ], { test: true });
  });

  it('should be able to receive events', function (done) {
    var client = new orchid.Client('ws://localhost:4567');

    client.on([ 'hello', 'universe' ], function (data) {
      data.should.eql({ test: true });
      done();
    });

    client.on('open', function () {
      client._ws.send('trigger 1');
    });
  });

  it('should be able to handle retries', function (done) {
    var server = null
      , client = new orchid.Client('ws://localhost:4589');

    setTimeout(function () {
      server = new orchid.Server();
      server.listen(4589);
    }, 200);

    client.on('open', function () {
      done();
    });
  });
});
