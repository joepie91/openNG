module.exports = (module) ->
	module.directive "viewLink", ->
		return {
			restrict: "A"
			link: (scope, element, attributes) ->
				element.on "click", (event) ->
					scope.$apply ->
						findViewScope = (scope) ->
							while true
								if scope.hasOwnProperty("_isWindowViewScope") and scope._isWindowViewScope
									return scope
								if not scope.$parent?
									return undefined
								scope = scope.$parent

						viewScope = findViewScope(scope)
						viewScope._currentRoute = attributes.viewLink
						event.preventDefault()
		}
