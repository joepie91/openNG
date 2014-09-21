module.exports = function(bookshelf) {
  return bookshelf.model("RelationshipType", {
    tableName: "relationship_types",
    idAttribute: "id"
  });
};
