CREATE OR REPLACE FUNCTION commonjs.plv8_startup() RETURNS BOOLEAN AS
$$
//  var plv8.context = [ ];

  plv8.require = function (module_name) {
    var query = "SELECT module_code FROM commonjs.plv8_modules WHERE module = $1";

    var module = { };
    var exports = { };

    plv8.elog(NOTICE, query);

    try {
//      if (plv8.context.length) {
//        module_name = plv8.context.join("/") + "/" + module_name;
//      }

      plv8.elog(NOTICE, "requiring " + module_name);
      var res = plv8.execute(query, [ module_name ]);

      if (res && res.length) {
//        plv8.context.push(module_name);
        eval(res[0].code);
//        plv8.context.pop();

        return exports;
      } else {
        return null;
      }
    } catch (err) {
      return null;
    }
  }

  // add console functionality
  plv8.console = {
    log: function ( ) {
      var args = Array.prototype.slice.call(arguments);
      plv8.elog(NOTICE, args.join(' '));
    },
    warn: function ( ) {
      var args = Array.prototype.slice.call(arguments);
      plv8.elog(WARNING, args.join(' '));
    },
    error: function ( ) {
      var args = Array.prototype.slice.call(arguments);
      plv8.elog(ERROR, args.join(' '));
    }
  };

  return true;
$$
LANGUAGE plv8 IMMUTABLE STRICT;
