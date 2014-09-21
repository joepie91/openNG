module.exports = (bookshelf) ->
	bookshelf.model "ProjectAuthorization",
		tableName: "project_autorizations"
		idAttribute: "id"