logger = require 'logmimosa'

retrieveRegistry = require('../util').retrieveRegistry

_list = ->
  retrieveRegistry (registry) ->
    registry.skels.forEach (skel) ->
      console.log skel

register = (program) ->
  program
    .command('skel:list')
    .description("List all skeletons")
    .option("-D, --debug", "run in debug mode")
    .action(_list)
    .on '--help', =>
      logger.green('  The skel:list will list all of the skeletons in the skeleton registry.')
      logger.green('  It will list all of the details for each skeleton.')
      logger.blue( '\n    $ mimosa skel:list\n')

module.exports = (program) -> register(program)