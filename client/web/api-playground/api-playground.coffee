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
			requestPermissions: [
				'email'
				'https://www.googleapis.com/auth/calendar'
				'https://www.googleapis.com/auth/contacts.readonly'
			]
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

	'click #schoolsListButton': (e) ->
		e.preventDefault()
		Meteor.call 'tags.schools',
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #setSchoolNameButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.setSchool',
			$('#schoolName').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #setNameButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.setName',
			$('#setName').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #setPictureButton': (e) ->
		e.preventDefault()
		file = $('#setPicture')[0].files[0]
		reader = new FileReader()
		reader.onerror = ->
			console.log 'Error reading file'
		reader.onload = (event) ->
			picture = event.target.result
			Meteor.call 'users.setPicture', picture,
				(error, result) ->
					if error
						console.log error
					else
						console.log result
		reader.readAsDataURL file

	'click #setPhoneNumberButton': (e) ->
		e.preventDefault()
		Meteor.call 'users.setPhoneNumber',
			$('#phoneNumber').val(),
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

	'click #retrieveContactsButton': (e) ->
		e.preventDefault()
		Meteor.call 'contacts.retrieve',
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #checkPhoneNumbersButton': (e) ->
		e.preventDefault()
		Meteor.call 'contacts.checkPhoneNumbers',
			$('#phoneNumbers').val().split(','),
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
			$('#calendarSyncUserId').val(),
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

	'click #channelUnwatchButton': (e) ->
		e.preventDefault()
		Meteor.call 'channels.unwatch',
			$('#channelId').val(),
			$('#resourceId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #insertEventButton': (e) ->
		e.preventDefault()
		event =
			summary: $('#insertEventSummary').val()
			start:
				dateTime: $('#insertEventStart').val()
			end:
				dateTime: $('#insertEventStart').val()
		Meteor.call 'events.insert',
			$('#insertEventCalendarId').val(),
			event,
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #updateEventButton': (e) ->
		e.preventDefault()
		event = {}
		event.summary = $('#updateEventSummary').val() if $('#updateEventSummary').val().length
		event.description = $('#updateEventDescription').val() if $('#updateEventDescription').val().length
		event.location = $('#updateEventLocation').val() if $('#updateEventLocation').val().length
		event.start = {}
		event.start.dateTime = $('#updateEventStart').val() if $('#updateEventStart').val().length
		event.end = {}
		event.end.dateTime = $('#updateEventEnd').val() if $('#updateEventEnd').val().length
		Meteor.call 'events.update',
			$('#updateEventId').val(),
			event,
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #deleteEventButton': (e) ->
		e.preventDefault()
		Meteor.call 'events.delete',
			$('#deleteEventId').val(),
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

	'click #getAttendees': (e) ->
		e.preventDefault()
		Meteor.call 'attendees.get',
			$('#getAttendeesEventId').val()
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #addAttendees': (e) ->
		e.preventDefault()
		attendees = []
		for email in $('#addAttendeesEmails').val().split(',')
			attendee = email: email
			attendees.push attendee 
		Meteor.call 'attendees.add',
			$('#addAttendeesEventId').val(),
			attendees,
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #removeAttendees': (e) ->
		e.preventDefault()
		attendees = []
		for email in $('#removeAttendeesEmails').val().split(',')
			attendee = email: email
			attendees.push attendee 
		Meteor.call 'attendees.remove',
			$('#removeAttendeesEventId').val(),
			attendees,
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #attendeesAcceptButton': (e) ->
		e.preventDefault()
		Meteor.call 'attendees.accept',
			$('#attendeesAcceptEventId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #attendeesDeclineButton': (e) ->
		e.preventDefault()
		Meteor.call 'attendees.decline',
			$('#attendeesDeclineEventId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #dbAttendeesAddButton': (e) ->
		e.preventDefault()
		attendee =
			phoneNumber: $('#dbAttendeesPhoneNumber').val()
		Meteor.call 'attendees.localAdd',
			$('#dbAttendeesAddEventId').val(),
			attendee,
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #dbAttendeesRemoveButton': (e) ->
		e.preventDefault()
		Meteor.call 'attendees.localRemove',
			$('#dbAttendeesRemoveEventId').val(),
			$('#dbAttendeesRemovePhoneNumber').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #dbAttendeesAcceptButton': (e) ->
		e.preventDefault()
		Meteor.call 'attendees.localAccept',
			$('#dbAttendeesAcceptEventId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #dbAttendeesDeclineButton': (e) ->
		e.preventDefault()
		Meteor.call 'attendees.localDecline',
			$('#dbAttendeesDeclineEventId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #dbAttendeesUpdateButton': (e) ->
		e.preventDefault()
		Meteor.call 'attendees.localUpdate',
			$('#dbAttendeesUpdateEventId').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #inviteWithSMSButton': (e) ->
		e.preventDefault()
		Meteor.call 'invitations.app.sms',
			$('#inviteWithSMSPhoneNumber').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #inviteEventWithSMSButton': (e) ->
		e.preventDefault()
		Meteor.call 'invitations.event.sms',
			$('#inviteEventWithSMSEventId').val(),
			$('#inviteEventWithSMSPhoneNumber').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #tagsDefineButton': (e) ->
		e.preventDefault()
		tags = [
			{
				category: 'a'
				tags: ['a', 'b', 'c', 'd']
			},
			{
				category: 'c'
				tags: ['e', 'f', 'g', 'j']
			}
		]
		Meteor.call 'tags.define',
			'SCU',
			tags,
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #tagsSchoolButton': (e) ->
		e.preventDefault()
		Meteor.call 'tags.school',
			$('#tagsSchoolName').val(),
			(error, result) ->
				if error
					console.log error
				else
					console.log result

	'click #tagsUserButton': (e) ->
		e.preventDefault()
		Meteor.call 'tags.user',
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