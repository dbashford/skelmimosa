"use strict"

newSkeleton = require('./lib/command/new')
#search = require('./lib/command/search')
#list = require('./lib/command/list')
#choose = require('./lib/command/choose')

exports.registerCommand = (program) ->

  newSkeleton(program)
  #search(program)
  #list(program)
  #choose(program)



