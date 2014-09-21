_ = require "lodash"
Promise = require "bluebird"

module.exports = (module) ->
	module.controller "appController", ($scope, windowRouter, windowManager) ->
		windowRouter
			.route "/node/:uuid",
				templateUrl: "/templates/node.html"
				controller: ($scope, $http) ->
					$scope.$on "windowClosing", (event, eventScope) ->
						eventScope.closing = false

					Promise.try ->
						$http.get "/node/#{$scope.routeParams.uuid}", responseType: "json"
					.then (response) ->
						_.assign $scope, response.data
			.route "/nodes/add",
				templateUrl: "/templates/nodes/add.html"
				controller: ($scope) ->


		$scope.$on "closeWindow", (event, targetScope) ->
			$scope.windows.splice targetScope.$parent.$index, 1

		$scope.windows = [
			data:
				title: "Sample window"
				resizable: true
				x: 48
				y: 48
				initialRoute: "/node/asdfg"
		,
			data:
				title: "Create new node"
				resizable: true
				x: 264
				y: 264
				width: 280
				height: 350
				initialRoute: "/nodes/add"
		]

