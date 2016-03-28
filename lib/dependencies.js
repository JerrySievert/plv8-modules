var required = require('required');

function get_tree (filename, callback) {
  required(filename, callback);
}

function get_entrypoint (path) {
  var package = require(path + '/package.json');

  return package.entry ? package.entry : 'index.js';
}

exports.get_tree = get_tree;
exports.get_entrypoint = get_entrypoint;
