module.exports = function(bookshelf) {
  return bookshelf.model("Attribute", {
    tableName: "attributes",
    idAttribute: "id"
  });
};
