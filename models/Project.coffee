module.exports = (bookshelf) ->
	bookshelf.model "Project",
		tableName: "projects"
		idAttribute: "id"