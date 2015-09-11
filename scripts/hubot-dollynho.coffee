# Description:
#   Give or take away Dollynhos.
#
# Commands:
#   <user>++ - Increment Dollys to an user.
#   <user>-- - Decrement Dollys to an user.
#   hubot conta - Receive users score.

class Dollynho
  constructor: (@robot) ->
    @cache = {}

    @increment_responses = [
      "vai ganhar um dolly!", "epa está ganhando muito! Dá um pra mim? :P"
    ]

    @decrement_responses = [
      "vai pagar um Dolly pra galera!", "se prepara pra comprar a fábrica :P", "paga mais um!? :D", "quanta bondade!!! :dollynho:"
    ]

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.dollynho
        @cache = @robot.brain.data.dollynho

  increment: (user) ->
    @cache[user] ?= 0
    @cache[user] += 1
    @robot.brain.data.dollynho = @cache

  decrement: (user) ->
    @cache[user] ?= 0
    @cache[user] -= 1
    @robot.brain.data.dollynho = @cache

  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]

  decrementResponse: ->
     @decrement_responses[Math.floor(Math.random() * @decrement_responses.length)]

  get: (user)->
    @cache[user]

  score: ->
    s = []

    for key, val of @cache
      s.push({ name: key, score: val })

    s.sort (a, b) -> b.score - a.score

module.exports = (robot) ->
  dollynho = new Dollynho robot

  robot.hear /(\S+[^+:\s])[: ]*\+\+(\s|$)/, (res) ->
    user = res.match[1].toLowerCase()
    room = res.message.room

    dollynho.increment user
    res.send "#{user} #{dollynho.incrementResponse()} (Conta: #{dollynho.get(user)})"

  robot.hear /(\S+[^-:\s])[: ]*--(\s|$)/, (res) ->
    user = res.match[1].toLowerCase()
    room = res.message.room

    dollynho.decrement user
    res.send "#{user} #{dollynho.decrementResponse()} (Conta: #{dollynho.get(user)})"

  robot.hear /conta/i, (res) ->
    verbiage = ["A Conta:"]

    for user, score in dollynho.score()
      verbiage.push "#{score + 1}. #{user.name} - #{user.score}"

    res.send verbiage.join("\n")
