module.exports = {
  conditionalClasses: function(always, conditionals) {
    var applicableClasses, applicableConditionals, className, condition;
    applicableConditionals = (function() {
      var _results;
      _results = [];
      for (className in conditionals) {
        condition = conditionals[className];
        if (condition) {
          _results.push(className);
        }
      }
      return _results;
    })();
    applicableClasses = always.concat(applicableConditionals);
    return applicableClasses.join(" ");
  }
};
