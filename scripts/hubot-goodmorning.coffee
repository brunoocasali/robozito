# Description:
#   Good morning responses.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   bom dia - Responde com bom dia!

module.exports = (robot) ->
  robot.hear /^bom dia/i, (res) ->
    good_morning_responses = [
      "bom dia pra quem?",
      "bom dia! :)",
      "jura que vc está em um bom dia hoje???",
      "bom dia!!",
      "nossa mano vc falando isso de novo?",
      "boa 06!",
      "O senhor é um fanfarrão!",
      "booooommmmm dia!",
      "O sistema é foda.",
      "Bom dia! Eu já te disse isso hoje!? Oo",
      "Traz um café pls!",
      "Se achando a pica das galáxias???",
      "Isso é hora????"
    ]

    res.send res.random good_morning_responses
