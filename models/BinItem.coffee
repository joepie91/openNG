module.exports = (bookshelf) ->
	bookshelf.model "BinItem",
		tableName: "bin_items"
		idAttribute: "id"