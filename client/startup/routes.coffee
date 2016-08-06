Router.route '/', ->
	@render 'apiPlayground'
	return

Router.route '/test', ->
	@render 'testPlayground'
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

Router.route '/calendarsFeeds', ->
	@render 'calendarsFeeds'
	return

Router.route '/eventsFeeds', ->
	@render 'eventsFeeds'
	return

Router.route '/tags/define/:school', ->
	@render 'defineTags'
	return