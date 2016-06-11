Template.calendars.onCreated ->
	@subscribe 'calendars.user'

Template.calendars.helpers
	calendars: ->
		Calendars.find()