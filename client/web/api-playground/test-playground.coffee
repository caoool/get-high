Template.testPlayground.onCreated ->
	@subscribe 'users.current', Meteor.userId()

Template.testPlayground.events

	'click #test': (e) ->
		e.preventDefault()
		console.log 'clicked'
		console.log Meteor.user().services.google.picture
		Meteor.call 'getGooglePicture', Meteor.user().services.google.picture,
			(error, result) ->
				if error
					console.log error
				else
					console.log result