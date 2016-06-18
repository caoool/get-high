Template.eventsFeeds.onCreated ->
	@subscribe 'events.feeds'

Template.eventsFeeds.helpers
	events: ->
		Events.find()