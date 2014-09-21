module.exports = (bookshelf) ->
	bookshelf.model "NodeTagAssociation",
		tableName: "node_tag_associations"
		idAttribute: "id"
		node: this.belongsTo "Node", "node_id"
		tag: this.belongsTo "NodeTag", "tag_id"