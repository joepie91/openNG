var module = angular.module("cryto.openng", ["cryto.jsde"]);

module.controller("appController", function($scope, jsdeRouteManager){
	jsdeRouteManager.when("/", {
		controller: "derpController",
		templateUrl: "templates/angular/index.html"
	});
});

module.controller("derpController", function($scope){
	
});
