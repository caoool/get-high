Template.calendars.onCreated ->
	@subscribe 'calendars.owner'

Template.calendars.helpers
	calendars: ->
		Calendars.find()