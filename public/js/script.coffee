_ = require "lodash"
$ = require "jquery"
angular = require "angular"
Promise = require "bluebird"

OverlayDrawer = require "./lib/OverlayDrawer"

# Sadly, we have to manually specify every single component path. We can't just
# loop over a list of component names and then assemble `require` paths, as that
# will confuse Browserify - it only supports literals.
components = []
components.push require "./providers/windowManager"
components.push require "./providers/windowRouter"
components.push require "./directives/ngDirectiveAttributes"
components.push require "./directives/window"
components.push require "./directives/windowView"
components.push require "./directives/viewLink"
components.push require "./controllers/appController"

# This is for Bluebird compatibility...
# Source: https://stackoverflow.com/a/23984472
trackDigests = (module) ->
	module.run ["$rootScope", ($rootScope) ->
		Promise.setScheduler (cb) ->
			$rootScope.$evalAsync cb
	]

module = angular.module "cryto.openng", []
trackDigests(module)

for component in components
	# Initialize the components with our newly created module
	component(module)

$ ->
	overlayDrawer = new OverlayDrawer($ "canvas.overlay")
	line = null

	###
	$document = $ document
		.on "mousedown", (event) ->
			line = overlayDrawer.createLine()
				.updateStart [event.pageX, event.pageY]
				.updateEnd [event.pageX, event.pageY]
				.setStyle lineColor: "red", lineWidth: 3
			$document.on "mousemove.canvasOverlay", (moveEvent) ->
				line.updateEnd [moveEvent.pageX, moveEvent.pageY]
		.on "mouseup", (event) ->
			$document.off "mousemove.canvasOverlay"
			overlayDrawer.removeObject line
	###
