module.exports = function(bookshelf) {
  return bookshelf.model("BinItem", {
    tableName: "bin_items",
    idAttribute: "id"
  });
};
