<form method="post" action="/nodes/create" class="pure-form pure-form-aligned form_createnode" data-hook-callback="callbackNodeCreated">
	<div class="toolbarwindow-contents">
		<div class="pure-g">
			<div class="form-block">
				<div class="pure-u-1">
					<h1 class="form">Node</h1>
				</div>
				
				<div class="formfield">
					<div class="pure-u-1-3 label">
						<label for="input_createnode_name">Name <i class="icon-exclamation-sign required"></i></label>
					</div>
					<div class="pure-u-2-3">
						<input class="pure-input-1" type="text" name="name" id="input_createnode_name">
					</div>
				</div>
				
				<div class="formfield">
					<div class="pure-u-1-3 label">
						<label for="input_createnode_notes">Notes</label>
					</div>
					<div class="pure-u-2-3">
						<textarea class="pure-input-1" name="notes" id="input_createnode_notes"></textarea>
					</div>
				</div>
			</div>
			
			<div class="form_createnode_properties form-block">
				<div class="pure-u-1">
					<h1 class="form">Properties</h1>
				</div>
				
				<div class="property">
					<input type="text" class="pure-input-1-2 group-first" name="property_name[]" placeholder="Name">
					<input type="text" class="pure-input-1-2 group-last" name="property_value[]" placeholder="Value">
				</div>
				
				<div class="property">
					<input type="text" class="pure-input-1-2 group-first" name="property_name[]" placeholder="Name">
					<input type="text" class="pure-input-1-2 group-last" name="property_value[]" placeholder="Value">
				</div>
			</div>
		</div>
	</div>
	<div class="toolbarwindow-toolbar">
		<button type="submit" class="pure-button okay shadow" data-submit-icon="icon-spinner icon-spin"><i class="icon-ok"></i>Create</button>
	</div>
</form>
