module.exports = (bookshelf) ->
	bookshelf.model "RelationshipReference",
		tableName: "relationship_references"
		idAttribute: "id"