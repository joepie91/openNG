module.exports = (bookshelf) ->
	bookshelf.model "Node",
		tableName: "nodes"
		idAttribute: "id"
		relationIdAttribute: "perma_id"
		type: -> this.belongsTo "NodeType", "type_id"
		tags: -> this.belongsToMany("NodeTag").through "NodeTagAssociation"
		attributes: -> this.hasMany "Attribute", "node_id"
