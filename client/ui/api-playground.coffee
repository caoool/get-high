Template.apiPlayground.onCreated ->
	@subscribe 'users.current', Meteor.userId()

Template.apiPlayground.events

	'click #addUserButton': (e) ->
		e.preventDefault()
		Accounts.createUser
			email: $('#username').val()
			password: $('#password').val()

	'click #loginUserButton': (e) ->
		e.preventDefault()
		Meteor.loginWithPassword $('#username').val(), $('#password').val()

	'click #logout': (e) ->
		e.preventDefault()
		Meteor.logout (error) ->
			if error then throw new (Meteor.Error)('Logout failed')

	'click #google-login': (e) ->
		e.preventDefault()
		Meteor.loginWithGoogle
			forceApprovalPrompt: true
			requestPermissions: ['email', 'https://www.googleapis.com/auth/calendar']
			requestOfflineToken: true
		, (error, result) ->
			if error
				console.log error
			else
				console.log result

	'click #loginWithTokenButton': (e) ->
		e.preventDefault()
		Meteor.loginWithToken $('#token').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #checkLoggedInButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.currentUser',
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #connectionTestButton': (e) ->
		e.preventDefault()
		Meteor.call 'conn.test',
			(error, result) ->
				if error
					console.log error
				else
					console.log 'DDP connected'

	'click #setSchoolNameButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.setSchool',
			$('#schoolName').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #likeEventButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.like',
			$('#likeEvent').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #unlikeEventButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.unlike',
			$('#unlikeEvent').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #getCalendarListButton': (e) ->
		e.preventDefault()
		Meteor.call 'calendars.list',
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #initCalendarButton': (e) ->
		e.preventDefault()
		Meteor.call 'calendars.init',
			$('#calendarId').val(),
			$('#calendarInitTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #syncCalendarButton': (e) ->
		e.preventDefault()
		Meteor.call 'calendars.sync',
			$('#calendarSyncId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #calendarWatchButton': (e) ->
		e.preventDefault()
		Meteor.call 'calendars.watch',
			$('#calendarWatchId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #calendarUnwatchButton': (e) ->
		e.preventDefault()
		Meteor.call 'calendars.unwatch',
			$('#calendarUnwatchId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #setEventVisibilityButton': (e) ->
		e.preventDefault()
		Meteor.call 'events.setVisibility',
			$('#setEventVisibilityId').val(),
			$('#setEventVisibilityType').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #calendarTagsButton': (e) ->
		e.preventDefault()
		Meteor.call 'calendars.setTags',
			$('#calendarIdSetTags').val(),
			$('#calendarTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #eventTagsButton': (e) ->
		e.preventDefault()
		Meteor.call 'events.setTags',
			$('#eventIdSetTags').val(),
			$('#eventTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #userTagsButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.setTags',
			$('#userTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #userClubsButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.setExcludedClubs',
			$('#userClubs').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result