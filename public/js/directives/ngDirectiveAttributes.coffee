# This is a handy little utility directive; it lets you apply HTML
# attributes from *within* a directive template, such that they are
# applied to the directive element *itself* upon linking. Note that
# for this to work, the ng-directive-attributes element should be
# at the very top level of your template. It also won't work (yet)
# with other directives; just static initialization-time values.

module.exports = (module) ->
	module.directive "ngDirectiveAttributes", ->
		return {
			restrict: "E"
			link: (scope, element, attributes) ->
				targetElement = element.parent()

				for jsName, htmlName of attributes.$attr
					attributeValue = attributes[jsName]
					switch htmlName
						when "class" then targetElement.addClass(className) for className in attributeValue.split(/\s+/)
						when "style"
							# CAUTION: This is a VERY naive parser! It's likely to break on edge cases.
							# FIXME: Make it deal correctly with "-wrapped and ()-wrapped values
							#        containing a colon (:).
							for pair in attributeValue.split ";"
								[key, value] = pair.split ":"
								targetElement.css key, value

						else targetElement.attr htmlName, attributeValue

				element.remove()
		}
