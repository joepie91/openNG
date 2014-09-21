module.exports = function(bookshelf) {
  return bookshelf.model("Bin", {
    tableName: "bins",
    idAttribute: "id"
  });
};
