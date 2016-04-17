
var tests = [
  {
    'require should be in scope': function ( ) {
      assert.equal(typeof require, 'function', 'require is a function');
    },
    'console should be in scope': function ( ) {
      assert.equal(typeof console, 'object', 'console is an object');
    },
    'console.log should be in scope': function ( ) {
      assert.equal(typeof console.log, 'function', 'console.log is a function');
    },
    'console.error should be in scope': function ( ) {
      assert.equal(typeof console.error, 'function', 'console.error is a function');
    },
    'console.warn should be in scope': function ( ) {
      assert.equal(typeof console.warn, 'function', 'console.warn is a function');
    }
  }
];
