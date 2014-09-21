module.exports = (bookshelf) ->
	bookshelf.model "BinProjectAssociation",
		tableName: "bin_project_associations"
		idAttribute: "id"