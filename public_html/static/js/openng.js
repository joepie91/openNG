function hookSubmitEvent(form, callback, error)
{
	/* Hooks a form to be submitted via AJAX, executing the given
	 * callback if the request succeeds.
	 * 
	 *  form: a jQuery object containing one or more form elements
	 *  callback: the function to run after a successful request
	 *  error: optionally, a callback function to run when the
	 *         request fails
	 */
	
	form.each(function(index){
		var element = $(this);
		var method = element.attr("method").toUpperCase();
		var target = element.attr("action");
		
		element.submit(function(){
			var formdata = element.serialize();
			console.log(formdata);
			$.ajax({
				type: method,
				url: target,
				data: formdata,
				success: callback,
				error: error
			});
			
			return false;
		});
	});
}

$(function(){
	hookSubmitEvent($("#form_search"));
	
	$("#button_toolbar_addnode").click(function(){
		new JsdeWindow({
			width: 320,
			height: 400,
			x: 40,
			y: 40,
			title: "Create new node",
			contents: "Loading...",
			source_url: "/nodes/create",
			noscroll: true
		});
	});
	
	/* Intro screen */
	new JsdeWindow({
		width: 640,
		height: 480,
		x: ($(window).width() / 2) - (640 / 2),
		y: ($(window).height() / 2) - (480 / 2),
		title: "Welcome!",
		contents: "Loading...",
		source_url: "/intro"
	});
});
