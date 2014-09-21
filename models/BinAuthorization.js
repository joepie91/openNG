module.exports = function(bookshelf) {
  return bookshelf.model("BinAuthorization", {
    tableName: "bin_authorizations",
    idAttribute: "id"
  });
};
