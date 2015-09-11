# Description:
#   Give or take away Dollynhos.
#
# Commands:
#   <user>++ - Ganha um Dolly.
#   <user>-- - Deve um Dolly.
#   hubot conta - Passa a conta.

class Dollynho
  constructor: (@robot) ->
    @storage = {}
    @storage.scores = {}
    @storage.log    = {}

    @increment_responses = [
      "vai ganhar um :dollynho:!",
      "epa está ganhando muito! Dá um pra mim? :P"
    ]

    @decrement_responses = [
      "vai pagar um :dollynho: pra galera! \o/",
      "se prepara pra comprar a fábrica :P",
      "paga mais um!? :D",
      "quanta bondade!!! :dollynho:"
    ]

    @verbiage_responses = [
      "passando a conta...",
      "um Lannister sempre paga suas dívidas...",
      "olha ae...",
      "cuidado com o SPC...",
      "conzinha espera pra quem não paga...",
    ]

    @robot.brain.on 'loaded', =>
      @storage = @robot.brain.data.dollynho ||= {
        scores: {}
        log: {}
      }

  increment: (sender, user) ->
    @storage.scores[user] ?= 0
    @storage.scores[user] += 1

    @log sender, user, '++'

    @robot.brain.save()

  decrement: (sender, user) ->
    @storage.scores[user] ?= 0
    @storage.scores[user] -= 1

    @log sender, user, '--'

    @robot.brain.save()

  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]

  decrementResponse: ->
     @decrement_responses[Math.floor(Math.random() * @decrement_responses.length)]

  verbiageResponse: ->
     @verbiage_responses[Math.floor(Math.random() * @verbiage_responses.length)]

  get: (user)->
    k = if @storage.scores[user] then @storage.scores[user] else 0

    return k

  score: ->
    s = []

    for key, val of @storage.scores
      s.push({ name: key, score: val })

    s.sort (a, b) -> b.score - a.score

  log: (sender, user, operation)->
    @storage.log = {}
    @storage.log[sender] = {}
    @storage.log[sender][user] = {}
    @storage.log[sender][user][operation] = {}

    @storage.log[sender][user][operation] = new Date()

module.exports = (robot) ->
  dollynho = new Dollynho robot

  robot.hear /(\S+[^+:\s])[: ]*\+\+(\s|$)/, (res) ->
    user   = res.match[1].toLowerCase()
    sender = res.message.user.name.toLowerCase()

    dollynho.increment sender, user
    res.send "#{user} #{dollynho.incrementResponse()} (Conta: #{dollynho.get(user)})"

  robot.hear /(\S+[^-:\s])[: ]*--(\s|$)/, (res) ->
    user = res.match[1].toLowerCase()
    sender = res.message.user.name.toLowerCase()

    dollynho.decrement sender, user
    res.send "#{user} #{dollynho.decrementResponse()} (Conta: #{dollynho.get(user)})"

  robot.hear /^conta$/i, (res) ->
    verbiage = [dollynho.verbiageResponse()]

    for user, score in dollynho.score()
      verbiage.push "#{score + 1}. #{user.name} - #{user.score}"

    res.send verbiage.join("\n")
