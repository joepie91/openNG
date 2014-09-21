module.exports = function(bookshelf) {
  return bookshelf.model("NodeType", {
    tableName: "node_types",
    idAttribute: "id",
    nodes: this.hasMany("Node", "type_id")
  });
};
