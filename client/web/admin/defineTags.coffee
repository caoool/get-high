##### defineTags
# DESCRIPTION
# 	This page will help admins create or update Tags List
# 	that belongs to a certain school. School name will be
# 	read from url /tags/define/:school. If such school does
# 	not exists, it will do creation instead of update.
# TODO
# 	Add validations (credentials) so only allowed admins
# 	can modify or create tags lists.
# 	


school = undefined
subscriptionHandler = undefined


Template.defineTags.onCreated ->

	school = Router.current().params.school
	subscriptionHandler = @subscribe 'tags.school', school


Template.defineTags.events

	'click #define': (e) ->
		e.preventDefault()
		file = $('#newTags')[0].files[0]
		reader = new FileReader()
		reader.readAsText file, 'json'
		reader.onerror = ->
			console.log 'Error reading file'
		reader.onload = (event) ->
			newTags = $.parseJSON event.target.result
			newTags = newTags.tags
			Meteor.call 'tags.define',
				school,
				newTags,
				(error, result) ->
					if error
						console.log error
					else
						console.log result



Template.defineTags.helpers

	school: ->
		school

	tag: ->
		Tags.findOne() if subscriptionHandler.ready()
