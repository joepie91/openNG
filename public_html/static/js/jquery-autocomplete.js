function AutoCompleter(type) {
	this.type = type;
	this.template = $(".autocompleter-template[data-template=" + type + "]");
}

AutoCompleter.prototype.spawn = function(source) {
	var instance = new AutoCompleterInstance(this.template.clone().removeClass("autocompleter-template").addClass("autocompleter-" + this.type).appendTo("body"), source);
	return instance;
}

function AutoCompleterInstance(element, source) {
	this.element = element;
	this.current_selection = 0;
	this.source = source;
}

AutoCompleterInstance.prototype.attachBelow = function(element) {
	var left = element.offset().left;
	var top = element.offset().top + element.outerHeight();
	
	this.target = element;
	this.element.css({left: left, top: top, display: "block"}).show();
	this.show();
	$(element).data("attached-autocomplete", this);
	this.element.data("autocomplete-object", this);
	this.element.disableSelection();
}

AutoCompleterInstance.prototype.remove = function() {
	this.unhookKeyEvents(this.target);
	this.unhookMouseEvents(this.target);
	this.hide();
	this.target.data("attached-autocomplete", "");
	this.element.remove();
}

AutoCompleterInstance.prototype.hookKeyEvents = function(element) {
	element.on("keyup.autocomplete", this._handleKeyUp.bind(this));
	element.on("keydown.autocomplete", this._handleKeyDown.bind(this));
	element.on("input.autocomplete", this._handleInput.bind(this));
}

AutoCompleterInstance.prototype.unhookKeyEvents = function(element) {
	element.off("keyup.autocomplete");
	element.off("keydown.autocomplete");
	element.off("input.autocomplete");
}

AutoCompleterInstance.prototype.hookMouseEvents = function(element) {
	this.element.on("mouseover.autocomplete", ".entry", this._handleMouseOver);
	this.element.on("mouseup.autocomplete", ".entry", this._handleMouseClick);
}

AutoCompleterInstance.prototype.unhookMouseEvents = function(element) {
	this.element.off("mouseover.autocomplete", ".entry");
	this.element.on("mouseup.autocomplete", ".entry");
}

AutoCompleterInstance.prototype._handleKeyUp = function(event) {
	switch(event.keyCode)
	{
		case 9:  // Tab
		case 13: // Enter/Return
			if(this.visible == true && this.total_items > 0)
			{
				this._selectCurrent();
				event.stopPropagation();
				event.preventDefault();
			}
			break;
	}
}

AutoCompleterInstance.prototype._handleKeyDown = function(event) {
	switch(event.keyCode)
	{
		case 9:  // Tab
		case 13: // Enter/Return
			/* We don't want this to do anything. */
			if(this.visible == true && this.total_items > 0)
			{
				event.stopPropagation();
				event.preventDefault();
			}
			break;
		case 38: // Arrow Up
			this._movePrevious();
			event.stopPropagation();
			event.preventDefault();
			break;
		case 40: // Arrow Down
			this._moveNext();
			event.stopPropagation();
			event.preventDefault();
			break;
		case 27: // Escape
			this.remove();
			break;
	}
}

AutoCompleterInstance.prototype._handleInput = function(event) {
	clearTimeout(this.update_timer);
	this.update_timer = setTimeout(this._updateItems.bind(this), 350);
}

AutoCompleterInstance.prototype._handleMouseOver = function(event) {
	var selected = $(this).data("position");
	var autocompleter = $(this).closest(".autocompleter").data("autocomplete-object");
	
	autocompleter.current_selection = selected;
	autocompleter._updateSelection();
}

AutoCompleterInstance.prototype._handleMouseClick = function(event) {
	var autocompleter = $(this).closest(".autocompleter").data("autocomplete-object");
	/* We ignore the actual represented entry; we just want to treat the currently highlighted entry
	 * as the one the user wants to select. In certain cases this is helpful for smooth UX, as it allows
	 * changing the selection while the mouse button is held - this may occur when the user changes his
	 * mind at the last moment. */
	autocompleter._selectCurrent();
}

AutoCompleterInstance.prototype._updateSelection = function() {
	this.element.find(".entry").removeClass("selected").eq(this.current_selection).addClass("selected");
}

AutoCompleterInstance.prototype._movePrevious = function() {
	/* We check validity afterwards to prevent race conditions (mouse vs. keyboard). */
	this.current_selection -= 1;
	
	if(this.current_selection < 0)
	{
		this.current_selection = 0;
	}
	
	this._updateSelection();
}

AutoCompleterInstance.prototype._moveNext = function() {
	this.current_selection += 1;
	
	if(this.current_selection > this.total_items - 1)
	{
		this.current_selection = this.total_items - 1;
	}
	
	this._updateSelection();
}

AutoCompleterInstance.prototype._selectCurrent = function() {
	var item = this.source.getItem(this.current_selection);
	
	if(typeof this.callback !== "undefined")
	{
		this.callback.call(this, item);
	}
	else
	{
		this.target.val(item.value);
	}
	
	this.remove();
}

AutoCompleterInstance.prototype._updateItems = function() {
	var query = this.target.val();
	
	if(query == "")
	{
		this.hide();
	}
	else
	{
		this.show();
	}
	
	this.element.find(".noresults, .results").hide();
	this.element.find(".loading").show();
	this.source.updateItems(query, this.continueUpdate.bind(this));
}

AutoCompleterInstance.prototype.continueUpdate = function() {
	this.total_items = this.source.getItemCount();
	
	if(this.total_items > 0)
	{
		this.element.find(".entry").slice(1).remove();
		
		var base_element = this.element.find(".entry").eq(0);
		var items = this.source.getAll();
		
		for(i in items)
		{
			var item = items[i];
			
			if(i == 0)
			{
				var current_element = base_element.addClass("selected").data("position", i);
			}
			else
			{
				var current_element = base_element.clone().appendTo(base_element.parent()).removeClass("selected").data("position", i);
			}
			
			current_element.find(".autocompleter-field").each(function(){
				$(this).html(item[$(this).data("field")]);
			});
		}
		
		this.element.find(".results").show();
		this.element.find(".noresults").hide();
	}
	else
	{
		this.element.find(".results").hide();
		this.element.find(".noresults").show();
	}
	
	this.element.find(".loading").hide();
}

AutoCompleterInstance.prototype.hide = function() {
	this.visible = false;
	this.element.hide();
	$(this.target).css({"border-bottom-left-radius": "", "border-bottom-right-radius": ""});
}

AutoCompleterInstance.prototype.show = function() {
	this.visible = true;
	this.element.show();
	$(this.target).css({"border-bottom-left-radius": 0, "border-bottom-right-radius": 0});
}

;(function($) {
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
	
	$.fn.autoComplete = function(autocompleter, source, callback) {
		this.on("input.autocomplete_hook", function(){
			if(!$(this).data("attached-autocomplete"))
			{
				var instance = autocompleter.spawn(source);
				instance.callback = callback;
				instance.attachBelow($(this));
				instance.hookKeyEvents($(this));
				instance.hookMouseEvents($(this));
				instance._updateItems();
				$(this).attr("autocomplete", "off");
			}
		});
		
		return this;
	};
}(jQuery));
