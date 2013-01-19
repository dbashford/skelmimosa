request = require 'request'
color = require('ansi-color').set

logger = require 'logmimosa'

exports.retrieveRegistry = (callback) ->
  logger.info "Retrieving registry..."

  request 'https://raw.github.com/dbashford/mimosa-skeleton/master/registry.json', (error, response, body) ->
    if not error and response.statusCode is 200
      try
        registry = JSON.parse body
        callback registry
      catch err
        logger.error "Registry JSON failed to parse: #{err}"
    else
      logger.error "Problem retrieving registry JSON: #{error}"

exports.outputSkeletons = (skels) ->

  console.log color("\n  ---------------------------------------------------------------------------------------\n", "green+bold")
  skels.forEach (skel) ->
    console.log "    #{color("Name:", "green+bold")}        #{color(skel.name, "blue+bold")}"
    console.log "    #{color("Description:", "green+bold")} #{skel.description}"
    #console.log "    #{color("Author:", "green+bold")}      #{skel.author}"
    console.log "    #{color("URL:", "green+bold")}         #{skel.url}"
    console.log "    #{color("Keywords:", "green+bold")}    #{skel.keywords.join(', ')}"
    console.log color("\n  ---------------------------------------------------------------------------------------\n", "green+bold")

