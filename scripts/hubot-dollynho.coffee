# Description:
#   catch plusplus event and post dollynho's message.
#
# Dependencies:
#   "hubot-plusplus": ">= 1.1.5"

class Dollynho
  constructor: (@robot) ->
    @increment_responses = [
      "vai ganhar um dolly!", "epa está ganhando muito! Dá um pra mim? :P"
    ]

    @decrement_responses = [
      "vai pagar um Dolly pra galera!", "se prepara pra comprar a fábrica :P", "paga mais um!? :D", "quanta bondade!!! :dollynho:"
    ]

  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]

  decrementResponse: ->
     @decrement_responses[Math.floor(Math.random() * @decrement_responses.length)]

module.exports = (robot) ->
  dollynho = new Dollynho robot

  robot.on "plus-one", (obj) ->
    name      = obj.name
    direction = obj.direction
    room      = obj.room
    reason    = obj.reason

    if direction == '++'
      msg = dollynho.incrementResponse()
    else
      msg = dollynho.decrementResponse()

    robot.send name, "#{msg}"
