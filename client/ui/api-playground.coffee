Template.apiPlayground.onCreated ->
	@subscribe 'users.current', Meteor.userId()

Template.apiPlayground.events
	'click #addUserButton': ->
		Accounts.createUser
			email: $('#username').val()
			password: $('#password').val()

	'click #loginUserButton': ->
		Meteor.loginWithPassword $('#username').val(), $('#password').val()

	'click #logout': ->
		Meteor.logout (error) ->
			if error then throw new (Meteor.Error)('Logout failed')

	'click #google-login': ->
		Meteor.loginWithGoogle 
			forceApprovalPrompt: true
			requestPermissions: ['https://www.googleapis.com/auth/calendar']
			requestOfflineToken: true
		, (error) ->
			if error
				console.log error
			else
				console.log 'logged in'

	'click #connectionTestButton': ->
		Meteor.call 'conn.test',
			(error, result) ->
				if error
					console.log error
				else
					console.log 'DDP connected'

	'click #setSchoolNameButton': ->
		Meteor.call 'users.setSchool',
			$('#schoolName').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #likeEventButton': ->
		Meteor.call 'users.like',
			$('#likeEvent').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #unlikeEventButton': ->
		Meteor.call 'users.unlike',
			$('#unlikeEvent').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #getCalendarListButton': ->
		Meteor.call 'calendars.list',
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #initCalendarButton': ->
		Meteor.call 'calendars.init',
			$('#calendarId').val(),
			$('#calendarInitTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #syncCalendarButton': ->
		Meteor.call 'calendars.sync',
			$('#calendarSyncId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #setEventVisibilityButton': ->
		Meteor.call 'events.setVisibility',
			$('#setEventVisibilityId').val(),
			$('#setEventVisibilityType').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	# 'click #watchCalendarButton':->
	# 	url = "/calendar/v3/calendars/#{$('#calendarId').val()}/events/watch"
	# 	data = 
	# 		id: '01234567-89ab-cdef-0123456789ab',
	# 		type: 'web_hook',
	# 		address: 'https://loopcowstudio.com/notifications'
	# 	GoogleApi.post url, {data: data},
	# 		(error, result) ->
	# 			if error
	# 				console.log error
	# 			else
	# 				console.log result

	# 'click #stopWatchCalendarButton': ->

	'click #calendarTagsButton': ->
		Meteor.call 'calendars.setTags',
			$('#calendarIdSetTags').val(),
			$('#calendarTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #eventTagsButton': ->
		Meteor.call 'events.setTags',
			$('#eventIdSetTags').val(),
			$('#eventTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #userTagsButton': ->
		Meteor.call 'users.setTags',
			$('#userTags').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #userClubsButton': ->
		Meteor.call 'users.setExcludedClubs',
			$('#userClubs').val().split(','),
			(error, result) ->
				if error
					console.log error
				else
					console.log result