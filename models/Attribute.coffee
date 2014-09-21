module.exports = (bookshelf) ->
	bookshelf.model "Attribute",
		tableName: "attributes"
		idAttribute: "id"
