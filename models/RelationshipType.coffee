module.exports = (bookshelf) ->
	bookshelf.model "RelationshipType",
		tableName: "relationship_types"
		idAttribute: "id"