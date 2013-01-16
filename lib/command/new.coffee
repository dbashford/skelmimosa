logger = require 'logmimosa'

###
1) If no input provided, take through prompt, show all skeletons
2) Allow name of skeleton from registry
3) Allow URL of skeleton from anywhere
4) Allow path to local skeleton for skel dev purposes
###

newSkeleton = (skeletonName, directory, opts) ->
  if opts.debug then logger.setDebug()

  console.log skeletonName
  console.log directory

register = (program) ->
  program
    .command('skel:new <skeletonName> <directory>')
    .description("Create a Mimosa project using a skeleton")
    .option("-D, --debug", "run in debug mode")
    .action(newSkeleton)
    .on '--help', =>
      logger.green('  The skel:new command will create a new project using a Mimosa skeleton of your choice.')
      logger.green('  The first argument passed to skel:new is the name of the skeleton to use.  The name can')
      logger.green('  take several forms.  It can be either the 1) name of the skeleton from the skeleton')
      logger.green('  registry, 2) the URL of the skeleton, presumably on github, or 3) the path to the skeleton')
      logger.green('  if the skeleton is on the file system for when skeleton development is taking place.')
      logger.green('  The second argument is the name of the directory to place the skeleton in. If the directory')
      logger.green('  does not exist, Mimosa will create it.')
      logger.blue( '\n    $ mimosa skel:new <skeletonName> <directory>\n')

module.exports = (program) -> register(program)

