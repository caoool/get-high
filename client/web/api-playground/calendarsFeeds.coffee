Template.calendarsFeeds.onCreated ->
	@subscribe 'calendars.feeds'

Template.calendarsFeeds.helpers
	calendars: ->
		Calendars.find()