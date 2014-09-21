module.exports = function(bookshelf) {
  return bookshelf.model("Node", {
    tableName: "nodes",
    idAttribute: "id",
    relationIdAttribute: "perma_id",
    type: function() {
      return this.belongsTo("NodeType", "type_id");
    },
    tags: function() {
      return this.belongsToMany("NodeTag").through("NodeTagAssociation");
    },
    attributes: function() {
      return this.hasMany("Attribute", "node_id");
    }
  });
};
