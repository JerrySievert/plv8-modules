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
$ bin/add_module -d database -h host -u username -p password --path ./cryptojs --name cryptojs
```

## Under the Hood

There is a small amount of _trickery_ going on under the hood, and this section
attempts to make everything clear so that it is easy to understand and extend.

### Namespacing

PLV8-Modules only works inside of the database that it has been instrumented
into.  The environment that it is installed into uses the `commonjs` _schema_,
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
`require()` method.

#### Requiring Modules

```js
var Cromag = require('cromag');

var date = new Cromag();
```
