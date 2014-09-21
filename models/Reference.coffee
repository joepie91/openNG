module.exports = (bookshelf) ->
	bookshelf.model "Reference",
		tableName: "references"
		idAttribute: "id"