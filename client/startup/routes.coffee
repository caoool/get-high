Router.route '/', ->
	@render 'apiPlayground'
	return

Router.route '/logger', ->
	@render 'logger'
	return

Router.route '/calendars', ->
	@render 'calendars'
	return

Router.route '/events', ->
	@render 'events'
	return
