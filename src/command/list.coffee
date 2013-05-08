logger = require 'logmimosa'

util = require('../util')
retrieveRegistry = util.retrieveRegistry
outputSkeletons = util.outputSkeletons

_list = ->
  retrieveRegistry (registry) ->
    logger.green('\n  The following skeletons are available for install. To use a skeleton find the name of the')
    logger.green('  skeleton you want and enter:')
    logger.blue('\n    mimosa skel:new [skeleton name] [name of directory to install skeleton] \n')

    logger.green('  To find skeletons that use specific technologies, use the mod:search command.')
    logger.blue('\n    mimosa skel:search backbone\n')

    logger.green('  Skeletons')

    outputSkeletons registry.skels

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