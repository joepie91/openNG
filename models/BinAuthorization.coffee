module.exports = (bookshelf) ->
	bookshelf.model "BinAuthorization",
		tableName: "bin_authorizations"
		idAttribute: "id"