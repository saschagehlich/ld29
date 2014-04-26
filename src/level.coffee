define [
  "ldfw",
  "entities/platform",
  "weapons/machinegun"
], (LDFW, Platform, MachineGun) ->
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

      @mobs = []

      @projectiles = []

    addMob: (mob) ->
      @mobs.push mob

    update: (delta) ->
      {player} = @gameState

      @_updateItems delta
      @_updateMobs delta
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

    _updateMobs: (delta) ->
      for mob in @mobs
        mob.update delta

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
        # Level boundary collision
        collideLeft = projectile.position.x < @boundaries.min.x
        collideRight = projectile.position.x > @boundaries.max.x
        collideFloor = projectile.position.y < @floorHeight
        if (collideLeft or collideRight or collideFloor) and
          not projectile.exploding
            projectile.explode()

            # Projectiles are pretty fast, make sure they stick to the walls
            projectile.position.x = @boundaries.min.x if collideLeft
            projectile.position.x = @boundaries.max.x if collideRight
            projectile.position.y = @floorHeight if collideFloor

        # Mob collision
        for mob in @mobs
          continue if mob.constructor.name is "Player"
          rect = projectile.getRect()
          if mob.intersectsWith(rect) and
            not projectile.exploding
              mob.hurt projectile.damage
              projectile.explode()
              console.log "OUCH"

        # Platform collision
        # for platform in @platforms
        #   if not (projectile.position.x < platform.x or
        #     projectile.position.x > platform.x + platform.width or
        #     projectile.position.y < platform.y or
        #     projectile.position.y > platform.y + platform.height) and
        #     not projectile.exploding
        #       projectile.explode()

        projectile.update delta

        # Throw away destroyed projectiles
        if projectile.destroyed
          destroyedProjectiles.push projectile

      for projectile in destroyedProjectiles
        @projectiles.splice(@projectiles.indexOf(projectile), 1)

    addProjectile: (projectile) ->
      @projectiles.push projectile
