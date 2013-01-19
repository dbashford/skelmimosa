{exec} = require 'child_process'
path =   require "path"
fs =     require "fs"

rimraf = require 'rimraf'
logger = require 'logmimosa'
wrench = require "wrench"

retrieveRegistry = require('../util').retrieveRegistry

windowsDrive = /^[A-Za-z]:\\/
_isSystemPath = (str) ->
  windowsDrive.test(str) or str.indexOf("/") is 0

_isGitHub = (s) ->
  s.indexOf("https://github") is 0 or s.indexOf("git@github") is 0 or s.indexOf("git://github") is 0

_newSkeleton = (skeletonName, directory, opts) ->
  if opts.debug then logger.setDebug()

  directory = "" unless directory?

  if _isGitHub(skeletonName)
    _cloneGitHub(skeletonName, directory)
  else if _isSystemPath(skeletonName)
    _moveDirectoryContents skeletonName, path.resolve directory
  else
    retrieveRegistry (registry) ->
      skels = registry.skels.filter (s) -> s.name is skeletonName
      if skels.length is 1
        logger.info "Found skeleton in registry"
        _cloneGitHub skels[0].url, directory
      else
        logger.error "Unable to find skeleton matching name [[ #{skeletonName} ]]"

_cloneGitHub = (skeletonName, directory) ->
  logger.info "Cloning GitHub repo [[ #{skeletonName} ]]"

  exec "git clone #{skeletonName} #{directory}", (error, stdout, stderr) ->
    return logger.error "Error cloning git repo: #{stderr}" if error?
    rimraf (path.join directory, '.git'), (error) ->
      if error?
        logger.error error
      else
        logger.success "Skeleton successfully cloned from GitHub."

_moveDirectoryContents = (sourcePath, outPath) ->
  contents = wrench.readdirSyncRecursive(sourcePath).filter (p) ->
    p.indexOf('.git') isnt 0 or p.indexOf('.gitignore') is 0

  unless fs.existsSync outPath
    fs.mkdirSync outPath

  for item in contents
    fullSourcePath = path.join sourcePath, item
    fileStats = fs.statSync fullSourcePath
    fullOutPath = path.join(outPath, item)
    if fileStats.isDirectory()
      logger.debug "Copying directory: [[ #{fullOutPath} ]]"
      wrench.mkdirSyncRecursive fullOutPath, 0o0777
    if fileStats.isFile()
      logger.debug "Copying file: [[ #{fullOutPath} ]]"
      fileContents = fs.readFileSync fullSourcePath
      fs.writeFileSync fullOutPath, fileContents

  logger.success "Copied local skeleton to [[ #{outPath} ]]"

register = (program) ->
  program
    .command('skel:new <skeletonName> [directory]')
    .description("Create a Mimosa project using a skeleton")
    .option("-D, --debug", "run in debug mode")
    .action(_newSkeleton)
    .on '--help', =>
      logger.green('  The skel:new command will create a new project using a Mimosa skeleton of your choice.')
      logger.green('  The first argument passed to skel:new is the name of the skeleton to use.  The name can')
      logger.green('  take several forms.  It can be either the 1) name of the skeleton from the skeleton')
      logger.green('  registry, 2) the github URL of the skeleton or 3) the path to the skeleton if the')
      logger.green('  skeleton is on the file system for when skeleton development is taking place. The second')
      logger.green('  argument is the name of the directory to place the skeleton in. If the directory does')
      logger.green('  not exist, Mimosa will create it.')
      logger.blue( '\n    $ mimosa skel:new <skeletonName> <directory>\n')

module.exports = (program) -> register(program)