module.exports = function(bookshelf) {
  return bookshelf.model("NodeTag", {
    tableName: "node_tags",
    idAttribute: "id",
    nodes: function() {
      var wrappedModel;
      wrappedModel = Object.create(bookshelf.model("NodeTag"));
      return wrappedModel.idAttribute = this.belongsToMany("NodeTag").through("NodeTagAssociation");
    }
  });
};
