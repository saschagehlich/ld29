module.exports = (grunt) ->
  grunt.initConfig

    coffee:
      dev:
        expand: true
        cwd: "src"
        src: "**/*.coffee"
        dest: "build/js/game"
        ext: ".js"

    texturepacker:
      sprites:
        src: ["assets/sprites"]
        options:
          scale: 2
          scaleMode: "fast"
          disableRotation: true
          trimMode: "None"
          maxSize: "4096"
          output:
            sheet:
              file: "build/assets/sprites.png"
              format: "png"
            data:
              file: "build/assets/sprites.json"
              format: "json"
      tiles:
        src: ["assets/tiles"]
        options:
          scale: 2
          scaleMode: "fast"
          disableRotation: true
          padding: 0
          trimMode: "None"
          algorithm: "Basic"

          basicSortBy: "Width"
          basicOrder: "Ascending"
          output:
            sheet:
              file: "build/assets/tiles.png"
              format: "png"
            data:
              file: "build/assets/tiles.json"
              format: "json"

      fonts:
        src: ["assets/fonts"]
        options:
          disableRotation: true
          padding: 0
          trimMode: "None"

          output:
            sheet:
              file: "build/assets/fonts.png"
              format: "png"
            data:
              file: "build/assets/fonts.json"
              format: "json"

    connect:
      site:
        options:
          port: 8080
          base: 'build'

    watch:
      dev:
        files: ["src/**/*.coffee"]
        tasks: ["newer:coffee"]
      sprites:
        files: ["assets/sprites/**/*"]
        tasks: ["texturepacker:sprites"]
      tiles:
        files: ["assets/tiles/**/*"]
        tasks: ["texturepacker:tiles"]
      fonts:
        files: ["assets/fonts/**/*"]
        tasks: ["texturepacker:fonts"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-texturepacker"
  grunt.loadNpmTasks "grunt-newer"

  grunt.registerTask "default", ["coffee", "texturepacker:sprites", "texturepacker:tiles", "texturepacker:fonts", "connect", "watch"]
