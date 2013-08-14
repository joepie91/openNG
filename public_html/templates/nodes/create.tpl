<form class="pure-form pure-form-aligned form_createnode">
	<h1 class="form">Node</h1>
	
	<div class="pure-control-group">
		<label for="input_createnode_name">Name</label>
		<input type="text" name="name" id="input_createnode_name">
	</div>
	
	<div class="pure-control-group">
		<label for="input_createnode_notes">Notes</label>
		<textarea name="notes" id="input_createnode_notes"></textarea>
	</div>
	
	<div class="pure-g form_createnode_properties">
		<div class="pure-u-1">
			<h1 class="form">Properties</h1>
		</div>
		
		<div class="property">
			<input type="text" class="pure-input-1-2 group-first" name="property_name[]" placeholder="Name">
			<input type="text" class="pure-input-1-2 group-last" name="property_value[]" placeholder="Value">
		</div>
	</div>
</form>
