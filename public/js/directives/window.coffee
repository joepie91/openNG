module.exports = (module) ->
	module.directive "window", (windowManager) ->
		return {
			restrict: "E"
			transclude: true
			templateUrl: "/templates/window.html"
			scope:
				_title: "@title"
				_x: "@startX"
				_y: "@startY"
				_width: "@width"
				_height: "@height"
				resizable: "@"
				initialRoute: "@"
			link: (scope, element, attributes) ->
				scope._currentRoute = scope.initialRoute
				scope._closing = false

				scope.title = scope._title
				scope.x = scope._x
				scope.y = scope._y
				scope.width = scope._width
				scope.height = scope._height

				# This is to deal with the fact that we can't pass 'undefined' through a HTML attribute...
				for field in ["x", "y", "title", "width", "height", "resizable", "initialRoute"]
					if scope[field] == ""
						scope[field] = null

				# If any of these values is updated, we still want to update the internal scope variables as well.
				scope.$watchCollection "[_title, _x, _y, _width, _height]", (newCollection, oldCollection) ->
					 for item in ["_title", "_x", "_y", "_width", "_height"]
							if oldCollection[item] != newCollection[item]
								scope[item[1...]] = newCollection[item]

				scope.setZIndex = (zIndex) ->
					element.css "z-index": zIndex

				scope.focusWindow = ->
					# Take focus
					windowManager.focusWindow scope.windowId

				windowId = windowManager.addWindow scope

				scope.windowElement = element.find(".window-wrapper")
				scope.windowId = windowId

				element.data "windowId", windowId

				scope.windowElement
					.on "mousedown", (event) ->
						scope.$apply ->
							scope.focusWindow()
							event.stopPropagation()

				scope.windowElement.find(".window-title")
					.on "mousedown", (event) ->
						scope.$apply ->
							windowManager.startDrag scope.windowId, [event.pageX - (scope.x ? 0), event.pageY - (scope.y ? 0)]

				scope.windowElement.find(".window-resizer")
					.on "mousedown", (event) ->
						scope.$apply ->
							windowManager.startResize scope.windowId, [event.pageX - (scope.width ? 400), event.pageY - (scope.height ? 300)]

				scope.windowElement.find(".window-close a")
					.on "click", (event) ->
						scope.$apply ->
							# We will set the window as 'closing', and broadcast an event to child
							# scopes. If a child scope wishes to cancel the close, they can simply
							# set 'closing' back to false.
							scope.closing = true
							scope.$broadcast "windowClosing", scope

				scope.$watch "closing", (newValue, oldValue) ->
					# If 'closing' is still set to true at this point, that means no
					# child scopes intercepted and cancelled the event. We'll emit
					# the event upwards, to let the actual window closure be handled
					# by whatever parent scope is instantiating these windows.
					if newValue != oldValue and newValue == true
						scope.$emit "closeWindow", scope


				scope.visible = true
		}
