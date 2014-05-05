retrieveRegistry = (logger, callback) ->
  request = require 'request'
  childProcess = require('child_process')

  logger.info "Retrieving registry..."
  childProcess.exec 'npm config get https-proxy', (error, stdout, stderr) ->
    options = {
      'uri': 'https://raw.github.com/dbashford/mimosa-skeleton/master/registry.json'
    }
    proxy = stdout.replace /(\r\n|\n\r|\n)/gm, ''
    if !error && proxy != 'null'
      options.proxy = proxy
    request options, (error, response, body) ->
      if error == null && response.statusCode == 200
        try
          registry = JSON.parse body
          callback registry
        catch err
          logger.error "Registry JSON failed to parse: #{err}"
      else
        logger.error "Problem retrieving registry JSON: #{error}"

outputSkeletons = (skels) ->
  color = require('ansi-color').set

  console.log color("  -----------------------------------------------------", "green+bold")
  skels.forEach (skel) ->
    console.log "  #{color("Name:", "green+bold")}        #{color(skel.name, "blue+bold")}"
    console.log "  #{color("Description:", "green+bold")} #{skel.description}"
    console.log "  #{color("URL:", "green+bold")}         #{skel.url}"
    console.log "  #{color("Keywords:", "green+bold")}    #{skel.keywords.join(', ')}"
    console.log color("  -----------------------------------------------------", "green+bold")

module.exports =
  outputSkeletons: outputSkeletons
  retrieveRegistry: retrieveRegistry
