Template.apiPlayground.onCreated ->
	@subscribe 'users.current', Meteor.userId()

Template.apiPlayground.events
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
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #syncCalendarButton': ->
		Meteor.call 'calendars.sync',
			$('#calendarId').val(),
			$('#calendar_id').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #watchCalendarButton':->
		url = "/calendar/v3/calendars/#{$('#calendarId').val()}/events/watch"
		data = 
			id: '01234567-89ab-cdef-0123456789ab',
			type: 'web_hook',
			address: 'https://loopcowstudio.com/notifications'
		GoogleApi.post url, {data: data},
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #stopWatchCalendarButton': ->