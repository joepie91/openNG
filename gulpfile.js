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

/* For Browserify task; see https://github.com/greypants/gulp-starter/blob/master/gulp/tasks/browserify.js */
var browserify   = require('browserify');
var watchify     = require('watchify');
var bundleLogger = require('./gulp.bundleLogger');
var handleErrors = require('./gulp.handleErrors');
var source       = require('vinyl-source-stream');

task = {
	"source": ["templateUtil.coffee", "routes/**/*.coffee", "models/**/*.coffee", "app.coffee", "util.coffee", "db.coffee"],
	"frontend": ["./public/js/script.coffee"],
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

gulp.task('browserify', function() {
	var bundler = browserify({
		cache: {}, packageCache: {}, fullPaths: true,
		entries: task.frontend,
		extensions: ['.coffee'],
		debug: true
	});

	var bundle = function() {
		bundleLogger.start();

		console.log("Bundling...");

		return bundler
			.bundle()
			.on('error', handleErrors)
			.pipe(source('bundled.js'))
			.pipe(gulp.dest('./public/js/'))
			.on('end', bundleLogger.end);
	};

	if(global.isWatching) {
		console.log("Starting Browserify watcher...");
		bundler = watchify(bundler);
		bundler.on('update', bundle);
	}

	return bundle();
});

gulp.task("jade", function() {
	return gulp.src(task.jade, {base: "./views/angular"})
		.pipe(plumber())
		.pipe(cache("jade"))
		.pipe(jade({locals: require("./templateUtil")}))
		.pipe(remember("jade"))
		.pipe(gulp.dest("public/templates"))
});

function checkServerUp(){
	setTimeout(function(){
		var sock = new net.Socket();
		sock.setTimeout(50);
		sock.on("connect", function(){
			console.log("Triggering page reload...");
			livereload.changed();
			sock.destroy();
		})
		.on("timeout", checkServerUp)
		.on("error", checkServerUp)
		.connect(3000);
	}, 70);
}

gulp.task('watch', function () {
	global.isWatching = true;
	livereload.listen();
	gulp.watch(task.jade, ['jade'])
	gulp.watch(['./**/*.css', 'views/**/*.jade', '!views/angular/**/*.jade', 'package.json']).on('change', livereload.changed);
	gulp.watch(['public/templates/**/*.html']).on('change', function() { livereload.changed("*"); }); // We need to explicitly reload everything here; Angular doesn't do partial reloading
	gulp.watch(task.source, ['coffee']);
	// theseus disabled for now, it was screwing with my tracebacks
	//nodemon({script: "./bin/www", ext: "js", nodeArgs: ['/usr/bin/node-theseus']}).on("start", checkServerUp);
	nodemon({script: "./bin/www", ext: "js", delay: 500}).on("start", checkServerUp);
});

gulp.task('default', ['coffee', 'jade', 'watch', 'browserify']);
