"use strict"

newSkeleton = require('./command/new')
list = require('./command/list')
search = require('./command/search')

exports.registerCommand = (program, logger, noop) ->
  newSkeleton program, logger
  list program, logger
  search program, logger
