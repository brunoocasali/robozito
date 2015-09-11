# Description:
#   Random a choice.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot moedinha "<option 1>" "<option 2>" "<option x>" - Tira na sorte uma opção.
#   hubot moedinha <option1> <option2> <option3> - Tira na sorte uma opção.


module.exports = (robot) ->
  robot.hear /moedinha "(.*)"/i, (msg) ->
    options = msg.match[1].split('" "')
    msg.send "Sorteado \"#{ msg.random options }\"! Boa sorte :P"

  robot.hear /moedinha ([^"]+)/i, (msg) ->
    options = msg.match[1].split(' ')
    msg.send "Sorteado \"#{msg.random options}\"! Boa sorte :P"
