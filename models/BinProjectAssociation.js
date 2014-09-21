module.exports = function(bookshelf) {
  return bookshelf.model("BinProjectAssociation", {
    tableName: "bin_project_associations",
    idAttribute: "id"
  });
};
