define ["ldfw", "entities/platform", "weapons/machinegun"], (LDFW, Platform, MachineGun) ->
  class Level
    floorHeight: 40
    scrollPosition: 0
    initialDepth: -1500
    depthPerPixel: 2 / 30
    constructor: (@game, @gameState) ->
      @gravity = new LDFW.Vector2(0, -4000)
      @boundaries =
        min: new LDFW.Vector2(105, 0)
        max: new LDFW.Vector2(@game.getWidth() - 50, 0)

      @platforms = [
        new Platform(420, 160, 100),
        new Platform(250, 250, 100),
        new Platform(420, 320, 100),
      ]

      @items = [
        new MachineGun(@game, @gameState, 450, 175)
      ]

      @projectiles = []

    update: (delta) ->
      {player} = @gameState

      @_updateItems delta
      @_updateProjectiles delta

      if player.position.y > @game.getHeight() / 2
        scrollPosition = player.position.y - @game.getHeight() / 2
      else
        scrollPosition = 0

      self = this
      TWEEN.remove @scrollTween
      @scrollTween = new TWEEN.Tween(this)
        .to({ scrollPosition }, 200)
        .easing(TWEEN.Easing.Quartic.Out)
        .start()

    _updateItems: (delta) ->
      {player} = @gameState

      removeItems = []
      for item in @items
        if player.intersectsWith(item.getRect())
          player.pickItem(item)
          removeItems.push item
        item.update(delta)

      for item in removeItems
        @items.splice(@items.indexOf(item), 1)

    _updateProjectiles: (delta) ->
      destroyedProjectiles = []
      for projectile in @projectiles
        if (projectile.position.x < @boundaries.min.x or
          projectile.position.x > @boundaries.max.x or
          projectile.position.y < @floorHeight) and
          not projectile.exploding
            projectile.explode()

        projectile.update delta
        if projectile.destroyed
          destroyedProjectiles.push projectile

      for projectile in destroyedProjectiles
        @projectiles.splice(@projectiles.indexOf(projectile), 1)

    addProjectile: (projectile) ->
      @projectiles.push projectile
