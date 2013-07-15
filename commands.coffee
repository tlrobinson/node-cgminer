
#         <name-->     <args->  <priv--->        <rep><details-->
REGEX = /^([\w-]+)(?:\|([^ ]+))?( \(\*\))?[\n\s]+(\w+)((?:.|\n)*)$/

exports.getCommands = ->
  docs = require("fs").readFileSync("#{__dirname}/commands.txt", "utf-8")
  parsed = docs.split(/\n\n /g).map (command) -> command.match REGEX
  commands = {}
  for command in parsed when command?
    commands[command[1]] =
      name: command[1]
      args: command[2]
      privileged: !!command[3]
      reply: if command[4] isnt "none" then command[4] else null
      details: command[5].split("\n").map((l) -> l.replace(/^\s+/, "")).join("\n")
  commands
