Template.testPlayground.onCreated ->
	@subscribe 'users.current', Meteor.userId()

Template.testPlayground.events

	'click #test': (e) ->
		e.preventDefault()
		Meteor.call 'testGraph',
			(error, result) ->
				if error
					console.log error
				else
					console.log result