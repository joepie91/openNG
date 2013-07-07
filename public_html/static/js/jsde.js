(function($){
	$.fn.disableSelection = function() {
		return this
		 .attr('unselectable', 'on')
		 .css('user-select', 'none')
		 .on('selectstart', false);
	};
	
	$.fn.enableSelection = function() {
		return this
		 .attr('unselectable', 'off')
		 .css('user-select', 'text')
		 .off('selectstart');
	};
	
	$.fn.getWindow = function() {
		return this.closest(".window-inner").data("jsde-window");
	};
})(jQuery);

var next_z_index = 1;
var currently_dragged_window = null;
var currently_dragging = false;
var drag_start = {x: 0, y: 0};
var currently_resized_window = null;
var currently_resizing = false;
var resize_start = {x: 0, y: 0};

$(function(){
	$("body").mousemove(_HandleMouseMove);
	$("body").mouseup(_HandleMouseUp);
})

function JsdeWindow(options)
{
	$.extend(this, options);
	
	this._outer = $("#jsde_templates .template_window").clone()[0];
	this._inner = $(this._outer).find(".window-inner")[0];
	this._title = $(this._outer).children(".window-title")[0];
	
	if(typeof options.visible !== "undefined" && options.visible == false)
	{
		this.Hide();
	}
	
	if(typeof options.title !== "undefined")
	{
		this.SetTitle(options.title);
	}
	
	if(typeof options.contents !== "undefined")
	{
		this.SetContents(options.contents);
	}
	
	if(typeof options.x === "undefined") { this.x = 0; }
	if(typeof options.y === "undefined") { this.y = 0; }
	if(typeof options.width === "undefined") { this.width = 250; }
	if(typeof options.height === "undefined") { this.height = 200; }
	if(typeof options.min_width === "undefined") { this.min_width = 120; }
	if(typeof options.min_height === "undefined") { this.min_height = 120; }
	if(typeof options.resizable === "undefined") { this.resizable = true; }
	
	this.SetPosition(this.x, this.y);
	this.SetSize(this.width, this.height);
	
	$(this._outer).click(this._HandleClick);
	$(this._outer).appendTo("body");
	
	$(this._title).mousedown(this._HandleMouseDown);
	
	$(this._outer).data("jsde-window", this)
	$(this._inner).data("jsde-window", this)
	$(this._title).data("jsde-window", this)
	
	$(this._outer).find(".window-close a").click(this._HandleClose);
	
	$(this._outer).find(".window-resizer").mousedown(this._HandleStartResize.bind(this));
	
	this.BringToForeground();
}

JsdeWindow.prototype.BringToForeground = function()
{
	this.z = next_z_index;
	$(this._outer).css({"z-index": next_z_index})
	next_z_index++;
	return this;
}

JsdeWindow.prototype.Close = function(forced)
{
	if(typeof forced === "undefined")
	{
		forced = false;
	}
	
	$(this._outer).remove();
}

JsdeWindow.prototype.GetContents = function()
{
	return $(this._inner).html();
}

JsdeWindow.prototype.GetTitle = function()
{
	return $(this._title).children(".window-title-inner").html();
}

JsdeWindow.prototype.Hide = function()
{
	this.visible = false;
	return $(this._outer).hide();
}

JsdeWindow.prototype.SetPosition = function(x, y)
{
	this.x = x;
	this.y = y;
	
	return $(this._outer).css({left: this.x, top: this.y});
}

JsdeWindow.prototype.GetPosition = function()
{
	return {x: this.x, y: this.y};
}

JsdeWindow.prototype.SetSize = function(width, height)
{
	this.width = width;
	this.height = height;
	
	return $(this._outer).css({width: this.width, height: this.height});
}

JsdeWindow.prototype.SetContents = function(html)
{
	console.log("set contents", html, this);
	return $(this._inner).html(html);
}

JsdeWindow.prototype.SetTitle = function(html)
{
	return $(this._title).children(".window-title-inner").html(html);
}

JsdeWindow.prototype.Show = function()
{
	this.visible = true;
	return $(this._outer).show();
}

JsdeWindow.prototype._HandleClick = function(event)
{
	$(this).data("jsde-window").BringToForeground();
}

JsdeWindow.prototype._HandleMouseDown = function(event)
{
	currently_dragging = true;
	currently_dragged_window = $(this).data("jsde-window");
	drag_start = {x: event.pageX - currently_dragged_window.x, y: event.pageY - currently_dragged_window.y};
	$(currently_dragged_window._outer).addClass("window-dragged");
	currently_dragged_window.BringToForeground();
	$("body").disableSelection();
	event.stopPropagation();
}

JsdeWindow.prototype._HandleClose = function(event)
{
	affected_window = $(this).closest(".window-title").data("jsde-window");
	affected_window.Close();
}

JsdeWindow.prototype._HandleStartResize = function(event)
{
	currently_resizing = true;
	currently_resized_window = this;
	resize_start = {x: event.pageX - (currently_resized_window.x + currently_resized_window.width), 
	                y: event.pageY - (currently_resized_window.y + currently_resized_window.height)};
	$(currently_resized_window._outer).addClass("window-dragged");
	currently_resized_window.BringToForeground();
	$("body").disableSelection();
	event.stopPropagation();
}

function _HandleMouseUp(event)
{
	if(currently_dragging === true)
	{
		currently_dragging = false;
		$("body").enableSelection();
		$(currently_dragged_window._outer).removeClass("window-dragged");
	}
	
	if(currently_resizing === true)
	{
		currently_resizing = false;
		$("body").enableSelection();
		$(currently_resized_window._outer).removeClass("window-dragged");
	}
}

function _HandleMouseMove(event)
{
	if(currently_dragging === true)
	{
		currently_dragged_window.SetPosition(event.pageX - drag_start.x, event.pageY - drag_start.y);
	}
	else if(currently_resizing === true)
	{
		var new_w = event.pageX - (resize_start.x + currently_resized_window.x);
		var new_h = event.pageY - (resize_start.y + currently_resized_window.y);
		
		if(typeof currently_resized_window.min_width !== "undefined" && new_w < currently_resized_window.min_width)
		{
			new_w = currently_resized_window.min_width;
		}
		
		if(typeof currently_resized_window.min_height !== "undefined" && new_h < currently_resized_window.min_height)
		{
			new_h = currently_resized_window.min_height;
		}
		
		if(typeof currently_resized_window.max_width !== "undefined" && new_w > currently_resized_window.max_width)
		{
			new_w = currently_resized_window.max_width;
		}
		
		if(typeof currently_resized_window.max_height !== "undefined" && new_h > currently_resized_window.max_height)
		{
			new_h = currently_resized_window.max_height;
		}
		
		currently_resized_window.SetSize(new_w, new_h);
	}
}
