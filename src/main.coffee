window.debug = ->
  if arguments.length > 0
    args = Array.prototype.slice.call arguments
    message = args.map((m) -> m.toString()).join(", ")
  else
    message = arguments[0]
  document.getElementById("debug").innerHTML = message

requirejs.config
  paths:
    jquery: "../lib/jquery/jquery"
    ldfw: "../lib/ldfw/ldfw"
    eventemitter: "../lib/eventEmitter/eventEmitter"
    async: "../lib/async/lib/async"
    tweenjs: "../lib/tweenjs/build/tween.min"

define [
  "jquery",
  "game",

  "tweenjs" # Not an AMD module
], ($, Game) ->
  $ ->
    window.game = new Game $("#game")
