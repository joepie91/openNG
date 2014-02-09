<div class="node-lookup pure-g">
	<div class="pure-u-3-5">
		<div class="unit-content">
			<h1>{%?name}</h1>
			<p>
				{%?notes}
			</p>
			<p>
				<strong>Node ID:</strong> {%?id}
			</p>
			
			<form class="pure-form property-add" method="post" action="/nodes/{%?id}/properties/add">
				<table class="pure-table pure-table-bordered">
					<thead>
						<tr>
							<th>Name</th>
							<th>Value</th>
						</tr>
					</thead>
					<tbody>
						{%foreach property in properties}
							<tr>
								<td class="property-name">{%?property[name]}</td>
								<td>
									{%?property[value]}
									{%if isempty|property[source] == false}
										<a class="source-ref" href="{%?property[source]}" target="_blank"><i class="icon-external-link"></i></a>
									{%/if}
								</td>
							</tr>
						{%/foreach}
						<!--
						<tr>
							<td class="property-name"><input class="input-propertyname" type="text" name="name" placeholder="Name"></td>
							<td><input type="text" name="value" placeholder="Value"></td>
						</tr>
						-->
					</tbody>
				</table>
			</form>
		</div>
	</div>
	<div class="pure-u-2-5">
		<div class="unit-content">
			<h2>Relationships</h2>
			<p>
				No relationships were found.
			</p>
		</div>
	</div>
</div>
