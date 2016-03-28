# PLV8-Modules

A CommonJS Module System for PLV8.

This is a work in progress, and will currently only install simple modules.

## Installing

```
$ bin/install_modules -d database -h host -u username -p password
```

### Modifying PostgreSQL Configuration

In order for Postgres and PLV8 to initialize with the CommonJS Module System,
a startup function must be created.

In `postgresql.conf`, add the following:

`plv8.start_proc = 'commonjs.plv8_startup'`

This should be added after the line that says `# Add settings for extensions here`,
and Postgres should then be started.

## Using

```
$ bin/add_module -d database -h host -u username -p password --module ./cryptojs --name cryptojs
```

## Under the Hood

There is a small amount of _trickery_ going on under the hood, and this section
attempts to make everything clear so that it is easy to understand and extend.

### Namespacing

PLV8-Modules only works inside of the database that it has been instrumented
into.  The environment that it is installed into uses the `commonjs` schema,
which gives it separation from the rest of the tables and functions.  It also
uses the `plv8` namespace to make `require` available to code that wants to use
the _commonjs_ module system.

### Storage

PLV8 is a *trusted* extension - it does not allow for direct access to a
filesystem, or networking.  To be able to make modules available, a table is
used to store the code and make it available via `require`.

| Column | Type | Description |
| :------------- | :------------- | :------------- |
| module | TEXT | Module Name |
| code | TEXT | Javascript Module |

All code is stored in the `plv8_modules` table, and is queried as part of the
`plv8.require()` method.

#### Requiring Modules

PLV8 separates execution context, which allows for a more secure environment,
but explicitly removes any global context except for the _plv8_ module itself.
The `require` method is bound to the _plv8_ namespace, which makes it available
to any _plv8_ function via `plv8.require()`:

```js
var Cromag = plv8.require('cromag');

var date = new Cromag();
```

#### Instrumentation

As part of the instrumentation process, `require` is assigned `plv8.require`,
and `console` is assigned `plv8.console`:

```
CREATE OR REPLACE FUNCTION yesterday() RETURNS TEXT AS
$$
  // instrumented
  var require = plv8.require;
  var console = plv8.console;

  // your code
  var Cromag = require('cromag');
  var yesterday = Cromag.yesterday();

  console.log("yesterday was " + yesterday.toYMD());

  return yesterday.toYMD();
$$
LANGUAGE plv8 IMMUTABLE STRICT;
```
