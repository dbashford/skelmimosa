module.exports = function(program, _logger) {
  var logger;
  logger = _logger;
  return program.command('skel:new <skeletonName> <directory>').description("Create a Mimosa project using a skeleton").option("-D, --mdebug", "run in debug mode").action(function(skeletonName, directory, opts) {
    var newSkel;
    newSkel = require("./impl/new");
    return newSkel(skeletonName, directory, opts, logger);
  }).on('--help', (function(_this) {
    return function() {
      logger.green('  The skel:new command will create a new project using a Mimosa skeleton of your choice.');
      logger.green('  The first argument passed to skel:new is the name of the skeleton to use.  The name can');
      logger.green('  take several forms.  It can be either the 1) name of the skeleton from the skeleton');
      logger.green('  registry, 2) the github URL of the skeleton or 3) the path to the skeleton if the');
      logger.green('  skeleton is on the file system for when skeleton development is taking place. The second');
      logger.green('  argument is the name of the directory to place the skeleton in. If the directory does');
      logger.green('  not exist, Mimosa will create it. If the directory is not provided, the skeleton will be');
      logger.green('  placed in the current directory.');
      return logger.blue('\n    $ mimosa skel:new <skeletonName> <directory>\n');
    };
  })(this));
};
