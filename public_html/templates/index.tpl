<!doctype>
<html>
	<head>
		<title>openNG</title>
		<link rel="stylesheet" href="/static/css/jsde.base.css">
		<link rel="stylesheet" href="/static/css/jsde.style.css">
		<script src="/static/js/jquery-1.10.2.min.js"></script>
		<script src="/static/js/jquery-timing.min.js"></script>
		<script src="/static/js/jsde.js"></script>
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
	<body>
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
		<div id="notification_area">
			<!-- Notifications go here. -->
		</div>
		<div id="jsde_templates">
			<div class="template_window window-wrapper window-styled">
				<div class="window-title">
					<span class="window-title-inner">
						
					</span>
					<div class="window-close">
						<a href="#">X</a>
					</div>
				</div>
				<div class="window-outer">
					<div class="window-inner-wrapper">
						<div class="window-inner">
						</div>
					</div>
					<div class="window-resizer">
					</div>
				</div>
			</div>
			<div class="template_notification notification-popup">
				<span class="notification-contents">
					<span class="notification-header">
						<i class="icon-info-sign pull-left notification"></i>
						Notification
					</span>
					<span class="message"></span>
				</span>
			</div>
			<div class="template_error error-popup">
				<span class="notification-contents">
					<span class="notification-header">
						<i class="icon-remove-sign pull-left error"></i>
						Error
					</span>
					<span class="message"></span>
				</span>
			</div>
		</div>
	</body>
</html>
