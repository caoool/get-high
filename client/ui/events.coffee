Template.events.onCreated ->
	@subscribe 'events.owner'

Template.events.helpers
	events: ->
		Events.find()