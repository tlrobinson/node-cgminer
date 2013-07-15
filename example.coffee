CGMinerClient = require "./index"

client = new CGMinerClient()

client.version().then (result) ->
  console.log result
  client.summary().then (result) ->
    console.log result
.done()
