"use strict";
var list, newSkeleton, search;

newSkeleton = require('./command/new');

list = require('./command/list');

search = require('./command/search');

exports.registerCommand = function(program, logger, noop) {
  newSkeleton(program, logger);
  list(program, logger);
  return search(program, logger);
};
