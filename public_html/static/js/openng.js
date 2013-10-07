(function($){
	$.fn.restoreIcon = function() {
		return this.removeClass().addClass(this.data("old-class"));
	};
})(jQuery);

var jsde_creation_hook = function(win)
{
	/* This function is a hook that is called after each creation of
	 * a JSDE window. */
	
}

var jsde_contents_hook = function(win)
{
	/* This function is a hook that is called after each time
	 * content is set in a JSDE window. */
	placeHooksForWindow(win);
}

notification_popups = [];
error_popups = [];
template_cache = {};

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
		var method = element.attr("method");
		var target = element.attr("action");
		
		if(typeof method !== "undefined")
		{
			method = method.toUpperCase();
		}
		else
		{
			method = "GET";
		}
		
		element.submit(function(){
			var submit_button = element.find("button[type=submit]");
			var submit_icon = submit_button.data("submit-icon");
			
			if(typeof submit_icon !== "undefined")
			{
				/* First we will try to replace an existing icon
				 * in the button. If there is no icon yet, the
				 * entire contents of the button will be replaced
				 * with the submission icon. */
				var current_icon = submit_button.find("i");
				
				if(current_icon.length == 0)
				{
					submit_button.html("<span style='text-align: center;'><i></i></span>");
					current_icon = element.find("i");
				}
				
				current_icon.data("old-class", current_icon.attr("class")).removeClass().addClass(submit_icon);
			}
			
			var formdata = element.serialize();
			console.log(formdata);
			
			$.ajax({
				type: method,
				url: target,
				data: formdata,
				dataType: "json",
				success: function(data, xhr){ console.log(data); callback(element, data, xhr); },
				error: function(data, xhr, err){ if(typeof error !== "undefined") { error(element, data, xhr, err); } /* This handles HTTP errors, NOT application errors! */ }
			});
			
			return false;
		});
	});
}

function placeHooksForWindow(win)
{
	console.log();
	$(win._outer).find("form").each(function(){
		var callback = $(this).data("hook-callback");
		var error_callback = $(this).data("hook-error-callback");
		
		if(typeof callback !== "undefined")
		{
			console.log("Hooking", this, "using callback", callback);
			hookSubmitEvent($(this), window[callback], window[error_callback]);
		}
	});
}

function callbackNodeCreated(form, data)
{
	if(data.result == "success")
	{
		spawnNotification(data.message);
		var node_id = data.node_id;
		
		form.getWindow().Close();
		
		new JsdeWindow({
			width: 480,
			height: 300,
			x: 100,
			y: 100,
			title: "Node lookup",
			contents: "Loading...",
			source_url: "/nodes/" + node_id
		});
	}
	else if(data.result == "error")
	{
		form.find("button[type=submit] i").restoreIcon();
		
		form.find("input, textarea").removeClass("invalid");
		
		if(data.errorfields)
		{
			for(i in data.errorfields)
			{
				var field_name = data.errorfields[i];
				form.find("input[name=" + field_name + "], textarea[name=" + field_name + "]").addClass("invalid");
			}
		}
		
		spawnError(data.message);
	}
}

/*function callbackNodeCreationFailed(form, data)
{
	form.find("button[type=submit]").restoreIcon();
}*/

function spawnNotification(message)
{
	var popup = spawnPopup(message, "notification");
	notification_popups.push(popup);
}

function spawnError(message)
{
	var popup = spawnPopup(message, "error");
	error_popups.push(popup);
}

function spawnPopup(message, template)
{
	var popup = $("#jsde_templates").find(".template_" + template).clone().removeClass("template_notification template_error");
	popup.find(".message").html(message.replace("\n", "<br>"));
	popup.hide();
	popup.prependTo("#notification_area");
	
	popup.fadeIn(300).wait(5000).fadeOut(400, $).remove();
	
	return popup
}

function spawnTemplate(name)
{
	if(!template_cache[name])
	{
		template_cache[name] = $("*[data-template-name=" + name + "]").first();
	}
	
	return template_cache[name].clone();
}

function SearchCompletionSource(element)
{
	this.element = element;
	this.results = [];
}

SearchCompletionSource.prototype.getItemCount = function() {
	return this.results.length;
}

SearchCompletionSource.prototype.getAll = function() {
	return this.results;
}

SearchCompletionSource.prototype.getItem = function(index) {
	return this.results[index];
}

SearchCompletionSource.prototype.updateItems = function(query, callback) {
	$.ajax({
		url: "/autocomplete/search/?q=" + escape(query),
		dataType: "json",
		success: function(result) { this.results = result; console.log(result); callback(); }.bind(this)
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
	
	spawnNotification("Test notification");
	spawnError("Test error");
	
	$("body").on("input", ".auto-duplicate input", function(){
		var parent = $(this).closest(".auto-duplicate");
		
		if(!parent.data("duplicated"))
		{
			spawnTemplate(parent.data("template-name")).insertAfter(parent).find("input").val("");
			parent.data("duplicated", true);
		}
	});
	
	autocompleter_search = new AutoCompleter("search");
	
	//setTimeout(function(){$("#input_search_query").autoComplete(autocompleter_search, new SearchCompletionSource($("#input_search_query")))}, 1000);
	
	$("#input_search_query").on("input", function(){
		if(!$(this).data("attached-autocomplete"))
		{
			$("#input_search_query").autoComplete(autocompleter_search, new SearchCompletionSource($("#input_search_query")), function(data){
				console.log(data);
			});
		}
	});
});
