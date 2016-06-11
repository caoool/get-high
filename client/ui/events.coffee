Template.events.onCreated ->
	@subscribe 'events.user'

Template.events.helpers
	events: ->
		Events.find()