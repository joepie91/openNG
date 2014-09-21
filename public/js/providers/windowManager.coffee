RateLimitedCall = require "../lib/RateLimitedCall"

module.exports = (module) ->
	module.factory "windowManager", ->
		$document = $(document)
		return {
			nextZIndex: 0
			nextId: 0
			windows: {}
			currentlyFocusedWindow: null
			currentlyDraggedWindow: null
			dragWindowOffset: null
			currentlyResizedWindow: null
			resizeWindowOffset: null
			positionCall: null

			disableSelection: (element = $document) ->
				element
					.attr "unselectable", "on"
					.css "user-select", "none"
					.on "selectstart", false

			enableSelection: (element = $document) ->
				element
					.attr "unselectable", "off"
					.css "user-select", "text"
					.off "selectstart"

			addWindow: (window) ->
				windowId = (@nextId += 1).toString() # Because otherwise comparisons will go derp...
				windowZIndex = @nextZIndex += 1
				@windows[windowId] = window

				window.$on "$destroy", (event) =>
					delete @windows[windowId]

				@focusWindow windowId
				return windowId

			startDrag: (targetWindowId, offset) ->
				@currentlyDraggedWindow = windowScope = @windows[targetWindowId]
				@dragWindowOffset = offset

				@disableSelection()

				@positionCall = new RateLimitedCall 30, ->
					windowScope.$apply =>
						windowScope.x = this.x
						windowScope.y = this.y

				$document.on "mousemove.dragWindow", (event) =>
					[offsetX, offsetY] = @dragWindowOffset
					@positionCall.call ->
						this.x = event.pageX - offsetX
						this.y = event.pageY - offsetY

				$document.on "mouseup.dragWindow", (event) =>
					# Clear events and reset internal state
					$document.off "mousemove.dragWindow"
					$document.off "mouseup.dragWindow"
					@currentlyDraggedWindow = null
					@dragWindowOffset = null
					@enableSelection()

			startResize: (targetWindowId, offset) ->
				@currentlyResizedWindow = windowScope = @windows[targetWindowId]
				@resizeWindowOffset = offset

				@disableSelection()

				@sizeCall = new RateLimitedCall 30, ->
					windowScope.$apply =>
						windowScope.width = this.w
						windowScope.height = this.h

				$document.on "mousemove.resizeWindow", (event) =>
					[offsetW, offsetH] = @resizeWindowOffset
					@sizeCall.call ->
						this.w = event.pageX - offsetW
						this.h = event.pageY - offsetH

				$document.on "mouseup.resizeWindow", (event) =>
					# Clear events and reset internal state
					$document.off "mousemove.resizeWindow"
					$document.off "mouseup.resizeWindow"
					@currentlyResizedWindow = null
					@resizeWindowOffset = null
					@enableSelection()

			focusWindow: (targetWindowId) ->
				for windowId, windowScope of @windows
					if windowId == targetWindowId
						# There's no point in wasting CPU cycles on focusing a window that's
						# already focused to begin with. Could also cause issues with z-index
						# consumption.
						if @currentlyFocusedWindow != windowScope
							windowScope.focused = true
							windowScope.setZIndex(@nextZIndex += 1)
							@currentlyFocusedWindow = windowScope
					else
						windowScope.focused = false
		}
