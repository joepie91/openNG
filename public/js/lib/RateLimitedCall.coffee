module.exports = class RateLimitedCall
	loopRunning: false
	_lastFrame: Date.now()

	constructor: (@fps, @frameHandler) ->
		@_interval = 1000 / @fps

	_loop: ->
		@loopRunning = true
		@_frame()

	_frame: ->
		now = Date.now()
		delta = now - @_lastFrame

		if delta > @_interval
			if @callActivated
				@frameHandler.apply(this)
				@callActivated = false
				@_lastFrame = now - (delta % @_interval)
			else
				@loopRunning = false

		if @loopRunning
			requestAnimationFrame @_frame.bind(this)

	_activateRateLimitedCall: ->
		@callActivated = true
		if not @loopRunning
			@_loop()

	call: (func) ->
		func.apply(this)
		@_activateRateLimitedCall()
