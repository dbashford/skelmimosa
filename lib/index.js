"use strict";
var list, newSkeleton, search;

newSkeleton = require('./command/new_command');

list = require('./command/list_command');

search = require('./command/search_command');

exports.registerCommand = function(program, logger, noop) {
  newSkeleton(program, logger);
  list(program, logger);
  return search(program, logger);
};
