<!doctype>
<html>
	<head>
		<title>openNG</title>
		<link rel="stylesheet" href="/static/css/jsde.base.css">
		<link rel="stylesheet" href="/static/css/jsde.style.css">
		<script src="/static/js/jquery-1.10.2.min.js"></script>
		<script src="/static/js/jsde.js"></script>
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
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Istok+Web:400,700">
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400,700">
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Varela+Round">
		<script>
			$(function(){
				new JsdeWindow({
					width: 640,
					height: 480,
					x: ($(window).width() / 2) - (640 / 2),
					y: ($(window).height() / 2) - (480 / 2),
					title: "Welcome!",
					contents: "Some kind of introduction should probably go here..."
				});
			});
		</script>
	</head>
	<body>
		<div id="logo">openNG</div>
		<!-- <div class="workspace-bar">
			<span id="workspace-tab-list">
				
			</span>
			<a class="workspace-tab workspace-tab-add" id="workspace_tab_add" href="#">+</a>
		</div> -->
		<div id="jsde_templates">
			<div class="template_window window-wrapper window-styled">
				<div class="window-title">
					<span class="window-title-inner">
						Test title
					</span>
					<div class="window-close">
						<a href="#">X</a>
					</div>
				</div>
				<div class="window-outer">
					<div class="window-inner">
						<strong>Test contents</strong>
					</div>
					<div class="window-resizer">
					</div>
				</div>
				<input type="hidden" name="MDIWindowIdentifier" value="1" class="MDIWindowIdentifier">
			</div>
		</div>
	</body>
</html>
