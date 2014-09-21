module.exports =
	conditionalClasses: (always, conditionals) ->
		applicableConditionals = (className for className, condition of conditionals when condition)
		applicableClasses = always.concat applicableConditionals
		return applicableClasses.join " "
