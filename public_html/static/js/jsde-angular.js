var module = angular.module('cryto.jsde', ["frapontillo.ex.filters", "ngRoute"]);

module.factory("jsdeRouteManager", function($routeProvider, $q) {
	/* This is a partial reimplementation of the routeProvider, and uses part of that.
	 * Since they already have routing figured out, we might as well implement a
	 * modified version that works on a window level. */
	var obj = {};
	
	obj.routes = {};
	
	obj.getParams = function(target) {
		var parts = target.split("?");
		keyValue = parts[1];
		return angular.parseKeyValue(keyValue);
	}
	
	/* Modified from angular router */
	obj.parseRoute = function(target, routes) {
		// Match a route
		var params, match;
		angular.forEach(routes, function(route, path) {
			if (!match && (params = $routeProvider.switchRouteMatcher(target, route))) {
				match = $routeProvider.inherit(route, {
					params: angular.extend({}, obj.getParams(target), params),
					pathParams: params});
				match.$$route = route;
			}
		});
		// No route matched; fallback to "otherwise" route
		return match || routes[null] && $routeProvider.inherit(routes[null], {params: {}, pathParams:{}});
	}
	
	/* Modified from angular router */
	obj.updateRoute = function(scope, element) {
		var next = obj.parseRoute(scope.path, obj.routes);
		var last = obj.lastRoute;
		
		if (next && last && next.$$route === last.$$route
				&& angular.equals(next.pathParams, last.pathParams)) {
			last.params = next.params;
			angular.copy(last.params, scope.params); // this sets the current route parameters so that other stuff can access it
		} else if (next || last) {
			obj.lastRoute = next;
			
			// actually change route
			var controller = next.$$route.controller;
			
			if (angular.isDefined(template = next.template)) {
				if (angular.isFunction(template)) {
					template = template(next.params);
				}
			} else if (angular.isDefined(templateUrl = next.templateUrl)) {
				if (angular.isFunction(templateUrl)) {
					templateUrl = templateUrl(next.params);
				}
				templateUrl = $sce.getTrustedResourceUrl(templateUrl);
				if (angular.isDefined(templateUrl)) {
					next.loadedTemplateUrl = templateUrl;
					var template = $http.get(templateUrl, {cache: $templateCache}).
						then(function(response) { return response.data; });
				}
			}
			
			var container = element.find(".window-inner");
			container.html(template);
			container.data('$ngControllerController', controller);
			container.children().data('$ngControllerController', controller);
		}
	}
	
	obj.when = function(path, route) {
		routes[path] = angular.extend(
			{reloadOnSearch: true},
			route,
			path && $routeProvider.pathRegExp(path, route)
		);

		// create redirection for trailing slashes
		if (path) {
			var redirectPath = (path[path.length-1] == '/')
						? path.substr(0, path.length-1)
						: path +'/';

			routes[redirectPath] = angular.extend(
				{redirectTo: path},
				$routeProvider.pathRegExp(redirectPath, route)
			);
		}

		return this;
	};
});

module.factory("manager", function($document, defaultFilter){
	var obj = {};
	
	obj.next_z_index = 0;
	obj.next_id = 0;
	obj.windows = {};
	obj.drag_mode = "none";
	obj.dragged_window = null;
	obj.dragged_scope = null;
	obj.drag_offset = null;
	
	obj.disablePageSelection = function() {
		angular.element("body")
		 .attr('unselectable', 'on')
		 .css('user-select', 'none')
		 .on('selectstart', false);
	};
	
	obj.enablePageSelection = function() {
		angular.element("body")
		 .attr('unselectable', 'off')
		 .css('user-select', 'text')
		 .off('selectstart');
	};
	
	obj.getNextZIndex = function()
	{
		obj.next_z_index += 1;
		return obj.next_z_index - 1;
	}
	
	obj.addWindow = function(scope, element)
	{
		var id = obj.next_id;
		obj.windows[id] = {scope: scope, element: element};
		obj.next_id += 1;
		return id;
	}
	
	obj.removeWindow = function(scope, element)
	{
		delete obj.windows[id];
	}
	
	obj.setAllUnfocused = function()
	{
		for(i in obj.windows)
		{
			obj.windows[i].scope.focused = false;
		}
	}
	
	$document.on("mousemove", function(event){
		if(obj.drag_mode == "move")
		{
			var new_x = event.pageX - obj.drag_offset.x;
			var new_y = event.pageY - obj.drag_offset.y;
			
			obj.dragged_scope.x = new_x;
			obj.dragged_scope.y = new_y;
			
			obj.dragged_scope.$apply();
		}
		else if(obj.drag_mode == "resize")
		{
			var new_width = event.pageX - obj.drag_offset.x;
			var new_height = event.pageY - obj.drag_offset.y;
			
			if(typeof obj.dragged_scope.minWidth !== "undefined" && new_width < obj.dragged_scope.minWidth)
			{
				new_width = obj.dragged_scope.minWidth;
			}
			else if(typeof obj.dragged_scope.maxWidth !== "undefined" && new_width > obj.dragged_scope.maxWidth)
			{
				new_width = obj.dragged_scope.maxWidth;
			}
			
			if(typeof obj.dragged_scope.minHeight !== "undefined" && new_height < obj.dragged_scope.minHeight)
			{
				new_height = obj.dragged_scope.minHeight;
			}
			else if(typeof obj.dragged_scope.maxHeight !== "undefined" && new_height > obj.dragged_scope.maxHeight)
			{
				new_height = obj.dragged_scope.maxHeight;
			}
			
			obj.dragged_scope.width = new_width;
			obj.dragged_scope.height = new_height;
			
			obj.dragged_scope.$apply();
		}
	});
	
	$document.on("mouseup", function(event){
		if(obj.drag_mode == "move" || obj.drag_mode == "resize")
		{
			obj.drag_mode = "none";
			obj.drag_offset = null;
			obj.enablePageSelection();
		}
	});
	
	obj.resolvePath = function(path) {
		
	}
	
	return obj;
});

module.directive("jsdeWindow", function(manager, defaultFilter, jsdeRouteProvider){
	return {
		restrict: "E",
		transclude: true,
		templateUrl: "templates/angular/jsde-window.html",
		scope: {
			title: "@",
			start_width: "@",
			start_height: "@",
			start_x: "@x",
			start_y: "@y",
			minWidth: "@",
			minHeight: "@",
			maxWidth: "@",
			maxHeight: "@",
			onScroll: "&",
			onClose: "&",
			visible: "@",
			_path: "@path"
		},
		link: function(scope, element, attrs) {
			manager.addWindow(scope, element);
			
			scope.x = scope.start_x;
			scope.y = scope.start_y;
			
			scope.width = scope.start_width;
			scope.height = scope.start_height;
			
			scope.defaults = {
				x: 48,
				y: 48,
				width: 400,
				height: 300
			}
			
			scope.$watch("_path", function(){
				scope.path = scope._path;
			});
			
			scope.$watch("path", function(){
				/* Update the view/controller pair for this path */
				jsdeRouteProvider.updateRoute(scope, element);
			})
			
			/* Set the initial z-index, this is to prevent glitches when clicking overlapping windows 
			 * in the same starting position */
			element.find(".window-wrapper").css({"z-index": manager.getNextZIndex()});
			
			/* Set the initial focus. */
			manager.setAllUnfocused();
			scope.focused = true;
			
			/* When any part of a window is clicked, it's raised to the top and set to 'focused'. */
			element.on("mousedown", function(){
				element.find(".window-wrapper").css({"z-index": manager.getNextZIndex()});
				manager.setAllUnfocused();
				scope.focused = true;
				scope.$apply();
			});
			
			element.find(".window-title").on("mousedown", function(event){
				/* Dragging is centrally managed by the JsdeManager, to prevent conflicts where
				 * two windows are in a 'dragging' state at the same time due to an event not
				 * firing. Developing for browsers isn't always roses and sunshine... */
				manager.drag_mode = "move";
				manager.dragged_window = element;
				manager.dragged_scope = scope;
				manager.drag_offset = {x: event.pageX - defaultFilter(scope.x, scope.defaults.x), y: event.pageY - defaultFilter(scope.y, scope.defaults.y)};
				manager.disablePageSelection();
			});
			
			element.find(".window-resizer").on("mousedown", function(event){
				/* Dragging is centrally managed by the JsdeManager, to prevent conflicts where
				 * two windows are in a 'dragging' state at the same time due to an event not
				 * firing. Developing for browsers isn't always roses and sunshine... */
				manager.drag_mode = "resize";
				manager.dragged_window = element;
				manager.dragged_scope = scope;
				manager.drag_offset = {x: event.pageX - defaultFilter(scope.width, scope.defaults.width), y: event.pageY - defaultFilter(scope.height, scope.defaults.height)};
				manager.disablePageSelection();
			});
			
			element.find(".window-title .window-close a").on("click", function(event){
				scope.$apply(function(){
					scope.visible = false;
					scope.onClose();
				});
			})
			
			scope.$watch("visible", function(newValue, oldValue){
				if(newValue !== oldValue)
				{
					if(newValue == true || newValue == "true") /* What the fuck? */
					{
						scope.$emit("jsdeWindowOpened");
						console.log("jsdeWindowOpened");
					}
					else
					{
						scope.$emit("jsdeWindowClosed");
						console.log("jsdeWindowClosed");
					}
				}
			});
			
			scope.path = "/";
		}
	}
});

module.directive("jsdeNotification", function(){
	return {
		restrict: "E",
		transclude: true,
		templateUrl: "templates/angular/jsde-notification.html",
		link: function(scope, element, attrs) {
			
		}
	}
});

module.directive("jsdeError", function(){
	return {
		restrict: "E",
		transclude: true,
		templateUrl: "templates/angular/jsde-error.html",
		link: function(scope, element, attrs) {
			
		}
	}
});
