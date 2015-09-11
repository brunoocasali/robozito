# Description:
#   catch plusplus event and post dollynho's message.
#
# Dependencies:
#   "hubot-plusplus": ">= 1.1.5"

class Dollynho
  constructor: (@robot) ->
    @increment_responses = [
      "vai pagar um Dolly pra galera!", "se prepara pra comprar a fábrica :P", "paga mais um!? :D", "quanta bondade!!! :dollynho:"
    ]

    @decrement_responses = [
      "está perdoado de um Dolly :( poxa queria 1!"
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

    robot.send direction

    if direction == '++'
      msg = dollynho.incrementResponse()
    else
      msg = dollynho.decrementResponse()

    robot.send name, "#{msg}"
