module.exports = function(bookshelf) {
  return bookshelf.model("AttributeType", {
    tableName: "attribute_types",
    idAttribute: "id"
  });
};
