define [
  "ldfw",
  "screens/game-screen",
  "player"
], (LDFW, GameScreen, Player) ->
  class Game extends LDFW.Game
    constructor: ->
      super

      # Preload assets
      @preloader = new LDFW.Preloader this, [
        "assets/sprites.json",
        "assets/sprites.png",
        "assets/fonts.json",
        "assets/fonts.png",
        "assets/fonts/pixel-8-white.fnt"
      ]
      @preloader.on "done", @_onPreloaded
      @preloader.load()

    ###
     * Gets called ~60 times per second. Update positions
     * etc. here
     * @param  {Number} delta
     * @private
    ###
    update: (delta) ->
      super
      TWEEN.update()

    ###
     * Gets called as soon as the preloader
     * has preloaded all assets
     * @private
    ###
    _onPreloaded: =>
      # Create a sprites atlas from the preloader
      # JSON and PNG
      spritesJSON = @preloader.get "assets/sprites.json"
      spritesImage = @preloader.get "assets/sprites.png"

      @spritesAtlas = new LDFW.TextureAtlas spritesJSON.frames, spritesImage

      fontsJSON = @preloader.get "assets/fonts.json"
      fontsImage = @preloader.get "assets/fonts.png"

      @fontsAtlas = new LDFW.TextureAtlas fontsJSON.frames, fontsImage

      @screen = new GameScreen this
      @run()

    ###
     * Gets the sprites atlas
     * @returns {LDFW.TextureAtlas}
     * @public
    ###
    getSpritesAtlas: -> @spritesAtlas
