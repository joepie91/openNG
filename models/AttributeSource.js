module.exports = function(bookshelf) {
  return bookshelf.model("AttributeSource", {
    tableName: "attribute_sources",
    idAttribute: "id"
  });
};
