$ = require "jquery"

class OverlayDrawer
	_objects: []
	_targetCanvas: null
	_pendingWindowResize: null
	_lastDraw: Date.now()
	_interval: 1000 / 30
	_processCommonStyles: (context, style) ->
		context.fillStyle = style.fillColor ? "transparent"
		context.strokeStyle = style.lineColor ? "black"
		context.globalAlpha = style.lineColor ? 1
		context.lineWidth = style.lineWidth ? 1
		context.lineCap = style.lineCap ? "butt"
		context.lineJoin = style.lineJoin ? "miter"
		context.miterLimit = style.miterLimit ? 10
		return context
	_drawFrame: =>
		now = Date.now()
		delta = now - @_lastDraw

		if delta > @_interval
			# Process any canvas resizes as a consequence of the parent window being resized by the user
			if @_pendingWindowResize
				[@_targetCanvas[0].width, @_targetCanvas[0].height] = @_pendingWindowResize
				@_targetCanvas.css
					width: @_pendingWindowResize[0]
					height: @_pendingWindowResize[1]
				@_pendingWindowResize = null

			# Clear the canvas
			context = @_targetCanvas[0].getContext("2d");
			context.clearRect 0, 0, @_targetCanvas[0].width, @_targetCanvas[0].height

			# Draw all the currently active objecs
			for object in @_objects
				object._draw context

			# The following assumes that frame draw duration < frame draw interval!
			# TODO: Investigate other approaches for doing this...
			@_lastDraw = now - (delta % @_interval)

		# If we still have objects left, request a new animation frame
		if @_objects.length > 0
			window.requestAnimationFrame @_drawFrame
	_triggerDraw: =>
		window.requestAnimationFrame @_drawFrame
	constructor: ($canvas) ->
		self = this # Duct-tape to make the resize event work correctly
		@_targetCanvas = $canvas

		$canvas.css
			position: "absolute"
			top: "0px"
			left: "0px"
			"z-index": "999999999"
			"pointer-events": "none"

		resizeHandler = ->
			self._pendingWindowResize = [$window.width(), $window.height()]

		$window = $ window
			.on "resize", resizeHandler

		# Do an initial resize to make our canvas stretch across the screen
		resizeHandler()
	removeObject: (object) =>
		@_objects = (obj for obj in @_objects when obj != object)
	createLine: =>
		newObj = new OverlayLine(this)
		@_objects.push newObj
		@_triggerDraw()
		return newObj

class OverlayLine
	constructor: (drawer) ->
		@_drawer = drawer
	_startPosition: null
	_endPosition: null
	_style: {}
	_draw: (context) =>
		context.beginPath()
		context.moveTo @_startPosition[0], @_startPosition[1]
		context.lineTo @_endPosition[0], @_endPosition[1]
		@_drawer._processCommonStyles context, @_style
		context.stroke()
	setStyle: (style) =>
		@_style = style
		return this
	updateStart: (position) =>
		@_startPosition = position
		return this
	updateEnd: (position) =>
		@_endPosition = position
		return this

module.exports = OverlayDrawer
