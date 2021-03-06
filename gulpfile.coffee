map        = require 'map-stream'
Duo        = require 'duo'
path       = require 'path'
gulp       = require 'gulp'
gutil      = require 'gulp-util'
coffee     = require 'gulp-coffee'
connect    = require 'gulp-connect'
rimraf     = require 'gulp-rimraf'


gulp.task "build", ["clean", "coffee", "styles", "index"]
gulp.task "default", ["build", "connect"]

gulp.task "clean", ->
  rimraf "./public"

gulp.task "coffee", ->
  gulp.src("src/scripts/scripts.coffee").pipe(coffee(bare: true).on("error", gutil.log)).pipe(gulp.dest("public")).pipe(duo()).pipe gulp.dest("public")
  return

gulp.task "styles", ->
  gulp.src("src/styles/styles.css").pipe(duo()).pipe gulp.dest("public")
  return

gulp.task "index", ->
  gulp.src("src/index.html").pipe gulp.dest("public")
  return

gulp.task "connect", ->
  connect.server(
    root: "public",
    port: 8000,
  )

duo = (opts) ->
  opts = opts or {}
  map (file, fn) ->
    Duo(file.base).entry(file.path).run (err, src) ->
      return fn(err)  if err
      file.contents = new Buffer(src)
      fn null, file
      return

    return
