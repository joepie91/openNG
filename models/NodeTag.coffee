module.exports = (bookshelf) ->
	bookshelf.model "NodeTag",
		tableName: "node_tags"
		idAttribute: "id"
		nodes: ->
			wrappedModel = Object.create(bookshelf.model("NodeTag"))
			wrappedModel.idAttribute = 
			this.belongsToMany("NodeTag").through "NodeTagAssociation" 