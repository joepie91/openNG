module.exports = function(bookshelf) {
  return bookshelf.model("ProjectAuthorization", {
    tableName: "project_autorizations",
    idAttribute: "id"
  });
};
