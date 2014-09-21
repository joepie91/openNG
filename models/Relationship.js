module.exports = function(bookshelf) {
  return bookshelf.model("Relationship", {
    tableName: "relationships",
    idAttribute: "id"
  });
};
