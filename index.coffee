"use strict"

exports.registerCommand = (program) ->

  require('./lib/command/new')(program)
  # require('./lib/command/search')(program)
  # require('./lib/command/list')(program)
  # require('./lib/command/choose')(program)



