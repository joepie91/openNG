var router;

router = require("express-promise-router")();

router.get("/", function(req, res) {
  return res.render("layout");
});

router.get("/node/:uuid", function(req, res) {
  return res.json({
    "uuid": req.params.uuid
  });
});

module.exports = router;
