module.exports = (bookshelf) ->
	bookshelf.model "Bin",
		tableName: "bins"
		idAttribute: "id"