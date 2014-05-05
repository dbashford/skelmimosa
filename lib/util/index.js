var outputSkeletons, retrieveRegistry;

retrieveRegistry = function(logger, callback) {
  var childProcess, request;
  request = require('request');
  childProcess = require('child_process');
  logger.info("Retrieving registry...");
  return childProcess.exec('npm config get https-proxy', function(error, stdout, stderr) {
    var options, proxy;
    options = {
      'uri': 'https://raw.github.com/dbashford/mimosa-skeleton/master/registry.json'
    };
    proxy = stdout.replace(/(\r\n|\n\r|\n)/gm, '');
    if (!error && proxy !== 'null') {
      options.proxy = proxy;
    }
    return request(options, function(error, response, body) {
      var err, registry;
      if (error === null && response.statusCode === 200) {
        try {
          registry = JSON.parse(body);
          return callback(registry);
        } catch (_error) {
          err = _error;
          return logger.error("Registry JSON failed to parse: " + err);
        }
      } else {
        return logger.error("Problem retrieving registry JSON: " + error);
      }
    });
  });
};

outputSkeletons = function(skels) {
  var color;
  color = require('ansi-color').set;
  console.log(color("  -----------------------------------------------------", "green+bold"));
  return skels.forEach(function(skel) {
    console.log("  " + (color("Name:", "green+bold")) + "        " + (color(skel.name, "blue+bold")));
    console.log("  " + (color("Description:", "green+bold")) + " " + skel.description);
    console.log("  " + (color("URL:", "green+bold")) + "         " + skel.url);
    console.log("  " + (color("Keywords:", "green+bold")) + "    " + (skel.keywords.join(', ')));
    return console.log(color("  -----------------------------------------------------", "green+bold"));
  });
};

module.exports = {
  outputSkeletons: outputSkeletons,
  retrieveRegistry: retrieveRegistry
};
