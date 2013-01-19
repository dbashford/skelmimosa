"use strict"

newSkeleton = require('./lib/command/new')
list = require('./lib/command/list')

#search = require('./lib/command/search')
#choose = require('./lib/command/choose')

exports.registerCommand = (program) ->
  newSkeleton program
  list program

  #search(program)
  #choose(program)



