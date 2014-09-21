module.exports = function(bookshelf) {
  return bookshelf.model("Reference", {
    tableName: "references",
    idAttribute: "id"
  });
};
