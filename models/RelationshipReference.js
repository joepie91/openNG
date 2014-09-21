module.exports = function(bookshelf) {
  return bookshelf.model("RelationshipReference", {
    tableName: "relationship_references",
    idAttribute: "id"
  });
};
