module.exports = function(bookshelf) {
  return bookshelf.model("RelationshipSource", {
    tableName: "relationship_sources",
    idAttribute: "id"
  });
};
