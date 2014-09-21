router = require("express-promise-router")()

router.get "/", (req, res) ->
	res.render "layout"

router.get "/node/:uuid", (req, res) ->
	res.json {"uuid": req.params.uuid}

module.exports = router
