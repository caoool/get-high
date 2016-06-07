Template.logger.onCreated ->
	@subscribe 'logs.fromNow'

Template.logger.helpers
	logs: ->
		Logs.find()
