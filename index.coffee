"use strict"

newSkeleton = require('./lib/command/new')
list = require('./lib/command/list')
#search = require('./lib/command/search')

exports.registerCommand = (program) ->
  newSkeleton program
  list program
  #search(program)



