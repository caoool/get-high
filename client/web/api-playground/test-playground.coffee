Template.testPlayground.onCreated ->
	@subscribe 'users.current', Meteor.userId()

Template.testPlayground.events

	'click #test': (e) ->
		e.preventDefault()
		console.log 'clicked'
		console.log Meteor.user().services.google.picture
		Meteor.call 'getGoogelPicture'