var should = require('chai').should();
var hl = require('../');


describe('highlight', function() {

  describe('#highlightAuto', function() {
    it('should auto determine language', function() {
      var jsString = 'var f = function(x, y, z) { \nvar a = 123;\nvar b = "test";\nvar c = x;\n };';
      var out = hl.highlightAuto(jsString);
      //console.log(out.value);
      out.keyword_count.should.equal(5);
      out.language.should.equal('javascript');
    });
  });

  describe('#highlight', function() {
    it('should take a language', function() {
      var jsString = 'var f = function(x, y, z) { \nvar a = 123;\nvar b = "test";\nvar c = x;\n };';
      var out = hl.highlight('javascript', jsString);
      out.keyword_count.should.equal(5);
    });
  });
});
