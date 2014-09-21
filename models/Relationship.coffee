module.exports = (bookshelf) ->
	bookshelf.model "Relationship",
		tableName: "relationships"
		idAttribute: "id"