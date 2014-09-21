_ = require "lodash"

module.exports = (module) ->
	module.factory "windowRouter", ->
		$document = $(document)
		obj = {
			routes: []
			_parseRoute: (selector) ->
				segments = selector.split "/"
				selector = for segment in segments
					if segment[...1] == ":"
						{type: "parameter", parameterName: segment[1...]}
					else
						{type: "string", string: segment}
				return selector
			_parsePath: (path) ->
				path.split "/"
			route: (selector, options) ->
				# options: templateUrl, controller
				selector = @_parseRoute selector
				@routes.push [selector, options]
				return this # For chaining purposes...
			findRoute: (path) ->
				path = @_parsePath path

				for [selector, options] in @routes
					options = _.clone(options)
					result = (->
						if selector.length != path.length
							# Different amount of segments; this can't possibly match.
							return false

						params = {}

						for i, segment of selector
							matches = switch segment.type
								when "string" then (segment.string == path[i])
								when "parameter"
									params[segment.parameterName] = path[i]
									true

							if not matches
								return false

						return params
					)()
					if result == false
						continue
					else
						# Match found, we got parameters.
						options.parameters = result
						return options

				# Still no matching routes found...
				throw new obj.RouterError("No matching routes found.")
		}

		obj.RouterError = (message) ->
			@name = "RouterError"
			@message = message
		obj.RouterError.prototype = new Error()
		obj.RouterError.prototype.construtor = obj.RouterError

		return obj
