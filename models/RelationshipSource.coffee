module.exports = (bookshelf) ->
	bookshelf.model "RelationshipSource",
		tableName: "relationship_sources"
		idAttribute: "id"