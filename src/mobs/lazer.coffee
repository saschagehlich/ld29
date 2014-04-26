define [
  "ldfw",
  "./flying-mob",
  "actors/mobs/lazer-actor"
], (LDFW, FlyingMob, LazerActor) ->
  class Lazer extends FlyingMob
    maxHealth: 20
    constructor: ->
      super

      @actor = new LazerActor(@game, @gameState, this)
      @hitBox = new LDFW.Rectangle(0, 0, 38, 38)

    update: (delta) ->
      super
      @actor.update delta
