"use strict"

newSkeleton = require('./command/new_command')
list = require('./command/list_command')
search = require('./command/search_command')

exports.registerCommand = (program, logger, noop) ->
  newSkeleton program, logger
  list program, logger
  search program, logger
