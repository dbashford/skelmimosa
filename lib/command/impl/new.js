var exec, fs, logger, newSkeleton, path, retrieveRegistry, rimraf, windowsDrive, wrench, _cleanup, _cloneGitHub, _isGitHub, _isSystemPath, _moveDirectoryContents, _runNPMInstall, _success;

exec = require('child_process').exec;

path = require("path");

fs = require("fs");

wrench = require("wrench");

rimraf = require("rimraf");

retrieveRegistry = require('../../util').retrieveRegistry;

logger = null;

windowsDrive = /^[A-Za-z]:\\/;

_success = function() {
  logger.success("New skeleton project successfully created!");
  logger.info("Inside the new project folder, run 'mimosa watch' to build and watch assets.");
  return logger.info("If the new project has server integration, add a '--server' or '-s' flag to serve assets.");
};

_isSystemPath = function(str) {
  return windowsDrive.test(str) || str.indexOf("/") === 0;
};

_isGitHub = function(s) {
  return s.indexOf("https://github") === 0 || s.indexOf("git@github") === 0 || s.indexOf("git://github") === 0;
};

_cloneGitHub = function(skeletonName, directory) {
  logger.info("Cloning GitHub repo [[ " + skeletonName + " ]] to temp holding directory.");
  wrench.rmdirSyncRecursive(path.join(process.cwd(), "temp-mimosa-skeleton-holding-directory"), true);
  return exec("git clone " + skeletonName + " temp-mimosa-skeleton-holding-directory", function(error, stdout, stderr) {
    var inPath;
    if (error != null) {
      return logger.error("Error cloning git repo: " + stderr);
    }
    inPath = path.join(process.cwd(), "temp-mimosa-skeleton-holding-directory");
    logger.info("Moving cloned repo to  [[ " + directory + " ]].");
    _moveDirectoryContents(inPath, directory);
    logger.info("Cleaning up...");
    _cleanup(directory);
    return _runNPMInstall(directory, function() {
      return rimraf(inPath, function(err) {
        if (err) {
          if (process.platform === 'win32') {
            logger.warn("A known Windows/Mimosa has made the directory at [[ " + inPath + " ]] unremoveable. You will want to clean that up.  Apologies!");
            return _success();
          } else {
            return logger.error("An error occurred cleaning up the temporary holding directory", err);
          }
        } else {
          return _success();
        }
      });
    });
  });
};

_runNPMInstall = function(directory, cb) {
  var currentDir, packageJSON;
  currentDir = process.cwd();
  process.chdir(directory);
  packageJSON = path.join(directory, "package.json");
  if (!fs.existsSync(packageJSON)) {
    return cb();
  }
  logger.info("Running npm install inside project directory...");
  return exec("npm install", function(err, sout, serr) {
    if (err) {
      logger.error(err);
    } else {
      console.log(sout);
    }
    if (logger.isDebug()) {
      logger.debug("Node module install sout: " + sout);
      logger.debug("Node module install serr: " + serr);
    }
    process.chdir(currentDir);
    return cb();
  });
};

_moveDirectoryContents = function(sourcePath, outPath) {
  var contents, fileContents, fileStats, fullOutPath, fullSourcePath, item, _i, _len;
  contents = wrench.readdirSyncRecursive(sourcePath).filter(function(p) {
    return p.indexOf('.git') !== 0 || p.indexOf('.gitignore') === 0;
  });
  if (!fs.existsSync(outPath)) {
    wrench.mkdirSyncRecursive(outPath, 0x1ff);
  }
  for (_i = 0, _len = contents.length; _i < _len; _i++) {
    item = contents[_i];
    fullSourcePath = path.join(sourcePath, item);
    fileStats = fs.statSync(fullSourcePath);
    fullOutPath = path.join(outPath, item);
    if (fileStats.isDirectory()) {
      logger.debug("Copying directory: [[ " + fullOutPath + " ]]");
      wrench.mkdirSyncRecursive(fullOutPath, 0x1ff);
    }
    if (fileStats.isFile()) {
      logger.debug("Copying file: [[ " + fullOutPath + " ]]");
      fileContents = fs.readFileSync(fullSourcePath);
      fs.writeFileSync(fullOutPath, fileContents);
    }
  }
  return _cleanup(outPath);
};

_cleanup = function(outPath) {
  return wrench.readdirSyncRecursive(outPath).filter(function(p) {
    return path.basename(p) === '.gitkeep';
  }).map(function(p) {
    return path.join(outPath, p);
  }).forEach(function(p) {
    return fs.unlinkSync(p);
  });
};

newSkeleton = function(skeletonName, directory, opts, _logger) {
  logger = _logger;
  if (opts.mdebug) {
    opts.debug = true;
    logger.setDebug();
    process.env.DEBUG = true;
  }
  directory = _isSystemPath(directory) ? directory : path.join(process.cwd(), directory);
  if (_isGitHub(skeletonName)) {
    return _cloneGitHub(skeletonName, directory);
  } else if (_isSystemPath(skeletonName)) {
    _moveDirectoryContents(skeletonName, directory);
    return _runNPMInstall(directory, function() {
      return logger.success("Copied local skeleton to [[ " + directory + " ]]");
    });
  } else {
    return retrieveRegistry(logger, function(registry) {
      var skels;
      skels = registry.skels.filter(function(s) {
        return s.name === skeletonName;
      });
      if (skels.length === 1) {
        logger.info("Found skeleton in registry");
        return _cloneGitHub(skels[0].url, directory);
      } else {
        return logger.error("Unable to find a skeleton matching name [[ " + skeletonName + " ]]");
      }
    });
  }
};

module.exports = newSkeleton;
