net = require "net"
Q = require "q"

class CGMinerClient
  constructor: (options = {}) ->
    @host = options.host or "127.0.0.1"
    @port = options.port or 4028
  request: (command, args...) ->
    deferred = Q.defer()
    socket = net.connect host: @host, port: @port
    socket.on "error", (err) ->
      deferred.reject err
    socket.on "connect", ->
      buffer = ""
      socket.on "data", (data) ->
        buffer += data.toString()
      socket.on "end", ->
        try
          deferred.resolve JSON.parse buffer.replace(/[^\}]+$/, "")
        catch err
          deferred.reject err
      socket.write JSON.stringify
        command: command
        parameter: args.join(",")
    deferred.promise

  _version: (r) -> r.VERSION[0]
  _devs: (r) -> r.DEVS

for device in ["pga", "gpu", "asc"]
  do (device) ->
    deviceUC = device.toUpperCase()
    CGMinerClient::["_#{device}"]      = (r) -> r["#{deviceUC}"][0]
    CGMinerClient::["_#{device}count"] = (r) -> r["#{deviceUC}S"][0].Count

CGMinerClient.commands = require("./commands").getCommands()

for name, command of CGMinerClient.commands
  do (name, command) ->
    CGMinerClient::[name] = (args...) ->
      @request.apply(@, [name].concat(args)).then (result) =>
        if @["_#{name}"]?
          Q.try => @["_#{name}"] result
        else
          result

module.exports = CGMinerClient
