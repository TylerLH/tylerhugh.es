gulp = require 'gulp'
$    = do require 'gulp-load-plugins'

gulp.task 'pages', ->
  gulp.src './src/**/*.jade'
  .pipe $.jade()
  .pipe gulp.dest './build'

gulp.task 'styles', ->
  $.rubySass './src/styles/app.scss'
    .pipe $.autoprefixer()
    .pipe gulp.dest './build'

gulp.task 'watch', ->
  gulp.watch './src/**/*.jade', ['pages']
  gulp.watch './src/**/*.scss', ['styles']

gulp.task 'serve', ->
  gulp.src './build'
  .pipe $.webserver
    livereload: true

gulp.task 'publish', ->
  publisher = $.awspublish.create
    profile: 'default'
    region: 'us-west-2'
    bucket: 'tylerhugh.es'

  gulp.src './build/**/*'
  .pipe publisher.publish()
  .pipe publisher.cache()
  .pipe $.awspublish.reporter()

gulp.task 'default', ['pages', 'styles']
gulp.task 'dev', ['default', 'serve', 'watch']