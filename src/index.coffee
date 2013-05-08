"use strict"

newSkeleton = require('./command/new')
list = require('./command/list')
search = require('./command/search')

exports.registerCommand = (program) ->
  newSkeleton program
  list program
  search program