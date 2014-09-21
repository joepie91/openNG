module.exports = (bookshelf) ->
	bookshelf.model "AttributeSource",
		tableName: "attribute_sources"
		idAttribute: "id"