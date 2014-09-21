module.exports = function(bookshelf) {
  return bookshelf.model("Project", {
    tableName: "projects",
    idAttribute: "id"
  });
};
