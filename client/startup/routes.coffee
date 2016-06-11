Router.route '/', ->
	@render 'apiPlayground'
	return

Router.route '/logger', ->
	@render 'logger'
	return