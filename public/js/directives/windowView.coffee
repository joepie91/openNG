module.exports = (module) ->
	module.directive "windowView", (windowRouter, $compile, $http, $controller, $templateCache) ->
		return {
			restrict: "A"
			link: (scope, element, attributes) ->
				scope.$watch "_currentRoute", (newValue, oldValue) ->
					route = windowRouter.findRoute newValue

					$http.get route.templateUrl, {cache: $templateCache}
						.then (response) ->
							newScope = scope.$new();

							# Shove the route parameters (if any) into the newly created scope
							newScope.routeParams = route.parameters

							# Continue creating the view. Controller, template, yadda yadda.
							newCtrl = $controller route.controller, {$scope: newScope}
							element.html response.data
							element.children().data "$ngControllerController", newCtrl
							$compile(element.contents())(newScope)

							# Clean up old scopes, and shift the old one...
							if scope._previousRouteScope?
								scope._previousRouteScope.$destroy()
							if scope._currentRouteScope?
								scope._previousRouteScope = scope._currentRouteScope
							scope._currentRouteScope = newScope
				scope._currentRoute = "/"
				scope._isWindowViewScope = true
		}
