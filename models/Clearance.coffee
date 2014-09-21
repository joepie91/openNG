module.exports = (bookshelf) ->
	bookshelf.model "Clearance",
		tableName: "clearances"
		idAttribute: "id"