module.exports = function(bookshelf) {
  return bookshelf.model("Clearance", {
    tableName: "clearances",
    idAttribute: "id"
  });
};
