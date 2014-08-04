var gulp = require('gulp');

/* CoffeeScript compile deps */
var path = require('path');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var coffee = require('gulp-coffee');
var cache = require('gulp-cached');
var remember = require('gulp-remember');
var plumber = require('gulp-plumber');
var livereload = require('gulp-livereload');
var nodemon = require("gulp-nodemon");
var jade = require("gulp-jade");
var net = require("net");

task = {
	"source": ["public/**/*.coffee", "routes/**/*.coffee", "models/**/*.coffee", "app.coffee", "util.coffee"],
	"jade": ["views/angular/**/*.jade"]
}

gulp.task('coffee', function() {
	return gulp.src(task.source, {base: "."})
		.pipe(plumber())
		.pipe(cache("coffee"))
		.pipe(coffee({bare: true}).on('error', gutil.log)).on('data', gutil.log)
		.pipe(remember("coffee"))
		.pipe(gulp.dest("."));
});

gulp.task("jade", function() {
	return gulp.src(task.jade)
		.pipe(plumber())
		.pipe(cache("jade"))
		.pipe(jade())
		.pipe(remember("jade"))
		.pipe(gulp.dest("public/templates"))
});
			   
function checkServerUp(){
	setTimeout(function(){ 
		var sock = new net.Socket();
		sock.setTimeout(50);
		sock.on("connect", function(){
			console.log("Trigger page reload...");
			livereload.changed();
			sock.destroy();
		})
		.on("timeout", checkServerUp)
		.on("error", checkServerUp)
		.connect(3000);
	}, 70);
}

gulp.task('watch', function () {
	livereload.listen();
	gulp.watch(['./**/*.css', 'views/**/*.jade', 'package.json']).on('change', livereload.changed);
	gulp.watch(task.source, ['coffee']);
	// theseus disabled for now, it was screwing with my tracebacks
	//nodemon({script: "./bin/www", ext: "js", nodeArgs: ['/usr/bin/node-theseus']}).on("start", checkServerUp);
	nodemon({script: "./bin/www", ext: "js"}).on("start", checkServerUp);
});

gulp.task('default', ['coffee', 'watch']);