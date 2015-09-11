# Description:
#   Give or take away Dollynhos.
#
# Commands:
#   <user>++ - Ganha um Dolly.
#   <user>-- - Deve um Dolly.
#   hubot passa a conta - Passa a conta.
#   hubot limpa capivara <user> - Limpa a capivara do usuário.

class Dollynho
  constructor: (@robot) ->
    @storage = {}

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
      "cozinha espera pra quem não paga...",
      "pega logo essa bagaça..."
    ]

    @offensive_responses = [
      "tu que me fude ne parceiro!?",
      "porra velho!",
      "mano que porra eh essa???",
      "mano tenho cara de palhaço?",
      "tah tirando!?!?!?"
    ]

    @robot.brain.on 'loaded', =>
      @storage = @robot.brain.data.dollynho

  increment: (sender, user) ->
    @storage[user] ?= 0
    @storage[user] += 1

    @robot.brain.data.dollynho = @storage

  decrement: (sender, user) ->
    @storage[user] ?= 0
    @storage[user] -= 1

    @robot.brain.data.dollynho = @storage

  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]

  decrementResponse: ->
     @decrement_responses[Math.floor(Math.random() * @decrement_responses.length)]

  verbiageResponse: ->
     @verbiage_responses[Math.floor(Math.random() * @verbiage_responses.length)]

  offensiveResponse: ->
     @offensive_responses[Math.floor(Math.random() * @offensive_responses.length)]

  get: (user)->
    k = if @storage[user] then @storage[user] else 0

    return k

  score: ->
    s = []

    for key, val of @storage
      s.push({ name: key, score: val })

    s.sort (a, b) -> b.score - a.score

  kill: (sender, user) ->
    delete @storage[user]
    @robot.brain.data.dollynho = @storage

module.exports = (robot) ->
  dollynho = new Dollynho robot

  robot.hear /(\S+[^+:\s])[: ]*\+\+(\s|$)/, (res) ->
    user   = res.match[1].toLowerCase()
    sender = res.message.user.name.toLowerCase()

    if sender != user
      dollynho.increment sender, user
      res.send "#{user} #{dollynho.incrementResponse()} (Conta: #{dollynho.get(user)})"
    else
      res.send "#{sender} #{dollynho.offensiveResponse()}"

  robot.hear /(\S+[^-:\s])[: ]*--(\s|$)/, (res) ->
    user = res.match[1].toLowerCase()
    sender = res.message.user.name.toLowerCase()

    if sender != user
      dollynho.decrement sender, user
      res.send "#{user} #{dollynho.decrementResponse()} (Conta: #{dollynho.get(user)})"
    else
      res.send "#{sender} #{dollynho.offensiveResponse()}"

  robot.hear /^passa a conta$/i, (res) ->
    verbiage = [dollynho.verbiageResponse()]

    for user, score in dollynho.score()
      verbiage.push "#{score + 1}. #{user.name} - #{user.score}"

    res.send verbiage.join("\n")

  robot.hear /^limpa capivara (\S+[^+:\s])$/i, (res) ->
    user = res.match[1].toLowerCase()
    sender = res.message.user.name.toLowerCase()

    if sender != user
      dollynho.kill sender, user
      res.send "#{sender} queima de arquivo concluída!"
    else
      res.send "#{sender} #{dollynho.offensiveResponse()}"
