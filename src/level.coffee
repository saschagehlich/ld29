define [
  "ldfw",
  "entities/platform",
  "weapons/bazooka"
], (LDFW, Platform, Bazooka) ->
  class Level
    floorHeight: 40
    scrollPosition: 0
    scrollSpeed: 1
    initialDepth: -1500
    depthPerPixel: 2 / 30
    platformDistance: 100
    platformIndex: 0
    minPlatformWidth: 100
    maxPlatformWidth: 250
    constructor: (@game, @gameState) ->
      @gravity = new LDFW.Vector2(0, -4000)
      @boundaries =
        min: new LDFW.Vector2(105, 0)
        max: new LDFW.Vector2(@game.getWidth() - 50, 0)

      @platforms = []

      @items = [
        new Bazooka(@game, @gameState, 450, 175)
      ]

      @mobs = []

      @projectiles = []

    addMob: (mob) ->
      @mobs.push mob

    update: (delta) ->
      {player} = @gameState

      @_updateItems delta
      @_updateProjectiles delta
      @_updateMobs delta

      @scrollPosition += @scrollSpeed

      @_buildPlatforms()

    _buildPlatforms: ->
      neededPlatformCount = Math.ceil((@scrollPosition + @game.getHeight() * 2) / @platformDistance)

      if @platformIndex < neededPlatformCount
        remainingPlatformsCount = neededPlatformCount - @platformIndex

        for i in [0...remainingPlatformsCount]
          @platformIndex++

          platformY = @floorHeight + @platformIndex * @platformDistance

          availableSpace = @game.getWidth() - @boundaries.min.x - (@game.getWidth() - @boundaries.max.x)
          platformWidth = @minPlatformWidth + Math.round(Math.random() * (@maxPlatformWidth - @minPlatformWidth))
          availableSpace -= platformWidth
          platformX = @boundaries.min.x + Math.round(Math.random() * availableSpace)

          platform = new Platform(platformX, platformY, platformWidth)
          @platforms.push platform

    _updateMobs: (delta) ->
      destroyedMobs = []
      for mob in @mobs
        mob.update delta

        if mob.destroyed
          destroyedMobs.push mob

      for mob in destroyedMobs
        @mobs.splice @mobs.indexOf(mob), 1

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
          continue if mob.destroyed or mob.exploding
          rect = projectile.getRect()
          if mob.intersectsWith(rect) and
            not projectile.exploding
              mob.hurt projectile.damage
              projectile.explode()

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
