function setup ( ) {
  plv8.execute("SET plv8.start_proc = 'commonjs.plv8_startup';");
}

var tests = [
  {
    'plv8.require should be in scope': function ( ) {
      assert.equal(typeof require, 'function', 'require is a function');
    }
  }
];
