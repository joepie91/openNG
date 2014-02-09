<!doctype>
<html ng-app="cryto.openng">
	<head>
		<title>openNG</title>
		<link rel="stylesheet" href="/static/css/jsde.base.css">
		<link rel="stylesheet" href="/static/css/jsde.style.css">
		<script src="/static/js/jquery-1.10.2.min.js"></script>
		<script src="/static/js/angular.min.js"></script>
		<script src="/static/js/jquery-timing.min.js"></script>
		<script src="/static/js/jquery-autocomplete.js"></script>
		<script src="/static/js/angular-filters.min.js"></script>
		<script src="/static/js/jsde-angular.js"></script>
		<script src="/static/js/openng.js"></script>
		<style>
			body
			{
				background-image: url(/static/images/background.jpg);
			}
			
			#logo
			{
				position: absolute;
				z-index: 0;
				right: 32px;
				top: 16px;
				color: white;
				font-size: 64px;
				font-family: 'Istok Web';
				font-weight: bold;
				color: #E2FFFF;
				text-shadow: 0px 0px 1px #CEE3F9;
				-webkit-text-shadow: 0px 0px 1px #CEE3F9;
				-moz-text-shadow: 0px 0px 1px #CEE3F9;
				-o-text-shadow: 0px 0px 1px #CEE3F9;
				-ms-text-shadow: 0px 0px 1px #CEE3F9;
			}
		</style>
		<link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.2.1/pure-min.css">
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Istok+Web:400,700">
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400,700">
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Varela+Round">
		<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css">
		<link rel="stylesheet" href="/static/css/openng.css">
	</head>
	<body ng-controller="appController">
		<div id="main_toolbar">
			<a href="#" class="pure-button add shadow" id="button_toolbar_addnode"><i class="icon-plus"></i>Create new node</a>
			
			<form class="pure-form inline" id="form_search" method="post" action="/search">
				<span class="element-group">
					<input type="text" id="input_search_query" name="query" value="" placeholder="Enter something to search for...">
					<button type="submit" class="pure-button search shadow" data-submit-icon="icon-spinner icon-spin"><i class="icon-search"></i>Search</button>
					<div class="clear"></div>
				</span>
			</form>
		</div>
		<div id="logo">openNG</div>
		<!-- <div class="workspace-bar">
			<span id="workspace-tab-list">
				
			</span>
			<a class="workspace-tab workspace-tab-add" id="workspace_tab_add" href="#">+</a>
		</div> -->
		
		
		<div id="autocomplete_search" class="autocompleter autocompleter-template" data-template="search">
			<div class="results">
				<div class="entry selected">
					<span class="autocompleter-field name" data-field="name">Name</span>
					<div class="clear"></div>
					<span class="autocompleter-field description" data-field="description">Description</span>
					<span class="autocompleter-field date" data-field="created">Creation date</span>
					<div class="clear"></div>
				</div>
			</div>
			<div class="noresults">
				No results.
			</div>
			<div class="loading">
				Searching...
			</div>
		</div>
		
		<div id="autocomplete_propertyname" class="autocompleter autocompleter-template" data-template="propertyname">
			<div class="results">
				<div class="entry selected">
					<span class="autocompleter-field name" data-field="value">Property name</span>
				</div>
			</div>
			<div class="noresults">
				No results.
			</div>
			<div class="loading">
				Searching...
			</div>
		</div>
		
		<div id="notification_area">
			<!-- Notifications go here. -->
		</div>
		
		<jsde-window title="hi!" visible="true" x="48" y="48" min-width="150" min-height="100" max-width="800" max-height="600">
			test
		</jsde-window>
	</body>
</html>
