if (!chai)
  var chai = require('chai');

var expect = chai.expect;

if (!oath)
  var oath = require('..');

function Spy (fn) {
  if (!fn) fn = function() {};

  function proxy() {
    var args = Array.prototype.slice.call(arguments);
    proxy.calls.push(args);
    proxy.called = true;
    fn.apply(this, args);
  }

  proxy.prototype = fn.prototype;
  proxy.calls = [];
  proxy.called = false;

  return proxy;
}

describe('Oath', function () {

  it('should have a version', function () {
    expect(oath.version).to.match(/^\d+\.\d+\.\d+$/);
  });

  it('should execute a success callback with arguments', function (done) {
    var success = Spy(function (data) {
      expect(data).to.eql({ doctor: 'who' });
    });

    var promise = function(data) {
      var o = new oath();
      setTimeout(function() {
        o.resolve(data);
        expect(success.called).to.be.ok;
        expect(success.calls).to.have.length(1);
        done()
      }, 10);
      return o.promise;
    };

    var h = promise({ doctor: 'who' }).then(success);
  });

  it('should execute a failure callback with arguments', function (done) {
    var failure = Spy(function (data) {
      expect(data).to.eql({ doctor: 'who' });
    });

    var promise = function(data) {
      var o = new oath();
      setTimeout(function() {
        o.reject(data);
        expect(failure.called).to.be.ok;
        expect(failure.calls).to.have.length(1);
        done()
      }, 10);
      return o.promise;
    };

    promise({ doctor: 'who' }).then(null, failure);
  });

  it('should not call the failure stack on success', function (done) {
    var success = Spy(function (data) {
      expect(data).to.eql({ doctor: 'who' });
    });

    var failure = Spy(function (data) {
      expect(true).to.not.be.ok;
    });

    var promise = function(data) {
      var o = new oath();
      setTimeout(function() {
        o.resolve(data);
        expect(success.called).to.be.ok;
        expect(success.calls).to.have.length(1);
        expect(failure.called).to.be.false;
        expect(failure.calls).to.have.length(0);
        done()
      }, 10);
      setTimeout(function() {
        o.reject(data);
      }, 20);
      return o.promise;
    };

    promise({ doctor: 'who' }).then(success, failure);
  });

  it('should accept the node callback converter - success', function (done) {
    var success = Spy(function (err, data) {
      expect(err).to.not.exist;
      expect(data).to.eql({ doctor: 'who' });
      done();
    });

    var promise = function (data) {
      var o = new oath();
      setTimeout(function() {
        o.resolve(data);
      }, 20);
      return o.promise;
    };

    promise({ doctor: 'who' }).node(success);
  });

  it('should accept the node callback converter - failure', function (done) {
    var failure = Spy(function (err, data) {
      expect(err).to.be.instanceof(Error);
      expect(data).to.not.exist;
      done();
    });

    var promise = function (data) {
      var o = new oath();
      setTimeout(function() {
        o.reject(new Error('Fake Error'));
      }, 20);
      return o.promise;
    };

    promise({ doctore: 'who' }).node(failure);
  });

  it('should not call the success stack on failure', function (done) {
    var success = Spy(function (data) {
      expect(true).to.not.be.ok;
    });

    var failure = Spy(function (data) {
      expect(data).to.eql({ doctor: 'who' });
    });

    var promise = function(data) {
      var o = new oath();
      setTimeout(function() {
        o.reject(data);
        expect(success.called).to.be.false;
        expect(success.calls).to.have.length(0);
        expect(failure.called).to.be.ok;
        expect(failure.calls).to.have.length(1);
        done()
      }, 10);
      setTimeout(function() {
        o.resolve(data);
      }, 20);
      return o.promise;
    };

    promise({ doctor: 'who' }).then(success, failure);
  });

  it('should execute async function in order', function (done) {
    var f1c = false
      , f2c = false;
    var f1 = function (res, next) {
      setTimeout(function() {
        expect(res).to.exist
          .and.to.have.property('doctor', 'who');
        expect(res).to.not.have.property('method');
        expect(res).to.not.have.property('companion');
        expect(next).to.be.a('function');
        expect(f1c).to.be.false;
        expect(f2c).to.be.false;
        f1c = true;
        res.method = 'tardis';
        next(res);
      }, 10);
    };

    var f2 = function (res) {
      expect(res).to.exist
        .and.to.have.property('doctor', 'who');
      expect(res).to.have.property('method', 'tardis');
      expect(f1c).to.be.true;
      expect(f2c).to.be.false;
      f2c = true;
      res.companion = 'k-9';
      return res;
    };

    var traveller = function() {
      var o = new oath();
      setTimeout(function() {
        o.resolve({ doctor: 'who' });
      }, 5);
      return o.promise;
    };

    traveller()
      .then(f1)
      .then(f2)
      .then(function(res) {
        expect(f1c).to.be.true;
        expect(f2c).to.be.true;
        expect(res).to.eql(
          { doctor: 'who'
          , method: 'tardis'
          , companion: 'k-9' });
        done();
      });
  });

  it('should execute items added to the chain after completion immediately', function () {
    var doctor = new oath()
      , n = 0;

    var depart = function () {
      expect(n).to.equal(0);
      n++;
    }

    var arrive = function () {
      expect(n).to.equal(1);
      n++;
    }

    doctor.promise.then(depart);
    doctor.resolve();
    doctor.promise.then(arrive);

    expect(n).to.equal(2);
  });

  it('should exectute items added to the chain after async fulfillment', function (done) {
    var doctor = new oath()
      , n = 0;

    var depart = function (res, next) {
      setTimeout(function () {
        expect(n).to.equal(0);
        next();
      }, 30);
      n++;
    }

    var arrive = function () {
      expect(n).to.equal(1);
      n++;
      done();
    }

    doctor.promise.then(depart);
    doctor.resolve();
    doctor.promise.then(arrive);
  });

  describe('internal node callback helper', function (done) {
    it('should work on failure', function (done) {
      var doctor = new oath();

      var success = function (a, b) {
        expect(true).to.be.false;
      }

      var failure = function (e) {
        expect(e).to.be.instanceof(Error);
        expect(arguments).to.have.length(1);
        done();
      }

      function depart (some, cb) {
        cb(new Error('No companion aboard. Dont leave!'));
      }

      doctor.promise.then(success, failure);
      depart('now', doctor.node());
    });

    it('should work on success', function (done) {
      var doctor = new oath();

      var success = function (res) {
        expect(arguments).to.have.length(1);
        expect(res).to.be.instanceof(Array);
        expect(res).to.eql([ 'k9', 'sj' ]);
        done();
      }

      var failure = function (e) {
        expect(false).to.be.true;
      }

      function depart (some, cb) {
        cb(null, ['k9', 'sj' ]);
      }

      doctor.promise.then(success, failure);
      depart('now', doctor.node());
    });
  });
});
