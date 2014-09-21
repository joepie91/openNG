module.exports = (bookshelf) ->
	bookshelf.model "AttributeType",
		tableName: "attribute_types"
		idAttribute: "id"