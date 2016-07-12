fields = '
	etag,
	nextPageToken,
	nextSyncToken,
	summary,
	description,
	items(
		id,
		etag,
		summary,
		description,
		start,
		end,
		location,
		status,
		visibility,
		hangoutLink,
		attendees(
			displayName,
			email,
			responseStatus),
		creator(
			displayName,email))
'

Meteor.methods


	# DESCRIPTION:
	# 	List will list all calendars asscociated with
	# 	the current user. 'id' being retured is unique
	# 	from google, and we will mainly use this id
	# 	as a parameter to make method calls. Calendar
	# 	list will not be saved in our database, so make
	# 	this method call to present calendar list.
	# RETURN:
	# 	{[Object]} -> id, summary, description
	# 	
	'calendars.list': ->

		future = new Future()
		future.throw credentialError if !@userId?

		url = '/calendar/v3/users/me/calendarList'
		options = params: fields: 'items(id,summary,description,accessRole)'

		GoogleApi.get url, options,
			(error, result) ->
				if error
					future.throw parseError error
				else
					future.return Calendars.filter result.items

		future.wait()


	# !!!
	# 	WIPE! ONLY INIT ON CREATION OR BROKEN!
	# 	USING 'primary' AS 'calendarId' IS RISTRICTED
	# DESCRIPTION:
	# 	Init will wipe the current calendar stored in
	# 	our database and clear all the events belongs
	# 	to it. Then it will initialize a full request
	# 	to Google Calendar API to receive and insert
	# 	the calendar itself and associated events.
	# RETURN:
	# 	Does not matter
	# TODO:
	# 	Google will passback a pageToken if items >
	# 	250. Limit of this number can be increased
	# 	to 2500, but still future implementation is
	# 	required to avoid error.
	# 	
	'calendars.init': (calendarId, tags=null) ->

		new SimpleSchema
			calendarId: type: String
			tags:
				type: [String]
				optional: true
		.validate
			calendarId: calendarId
			tags: tags

		future = new Future()
		future.throw credentialError if !@userId?

		url = "/calendar/v3/calendars/#{calendarId}/events"
		options = params: fields: fields

		GoogleApi.get url, options,
			(error, result) ->
				if error
					future.throw parseError error
				else
					result.id = calendarId
					result.school = Meteor.user().profile.school
					result.club = result.summary
					result.tags = tags

					Calendars.insert result, result.items,
						(error) ->
							if error
								future.throw parseError error
							else
								Meteor.call 'calendars.watch', calendarId,
									(error) ->
										if error
											future.throw parseError error
										else
											future.return result

		future.wait()


	# DESCRIPTION:
	# 	Sync will use the existing nextSyncToken
	# 	(syncToken) stored with the calendar to
	# 	call Google events API.
	# 	In our database, calendar's nextSyncToken
	# 	will be updated for next sync, events that
	# 	has changed will also apply to our events
	# 	associated with the calendar.
	# 	Types of event update:
	# 	-> status: cancelled (deletion)
	# 	-> status: confirmed (update or insertion)
	# RETURN:
	#   Does not matter
	#   
	'calendars.sync': (calendarId, userId=null) ->

		new SimpleSchema
			calendarId: type: String
			userId:
				type: String
				optional: true
		.validate
			calendarId: calendarId
			userId: userId

		future = new Future()

		calendar = Calendars.findOne id: calendarId

		if calendar?

			url = "/calendar/v3/calendars/#{calendarId}/events"
			options = params:
				syncToken: calendar.nextSyncToken
				fields: fields
			options.user = Meteor.users.findOne userId if userId

			GoogleApi.get url, options,
				(error, result) ->
					if error
						future.throw parseError error
					else if result.etag == calendar.etag
						future.return 'No changes since last sync'
					else
						Calendars.update {id: calendarId}, {$set: result}, result.items,
							(error) ->
								if error
									future.throw parseError error
								else
									Logs.log "...DDP...METHOD:: calendars.sync >> Calendar #{calendar.id} updated"
									future.return result

		else
			future.throw 500, 'Calendar not found'

		future.wait()


	# !!!
	# 	SHOULD NOT BE CALLED MANUALLY! 
	# 	IT WILL AUTOMATICALLY EXECUTES ON INITIATION.
	# DESCRIPTION
	# 	Watch change for a given calendar, establish
	# 	a notification channel between google and our
	# 	server. Whenever a change on a event belongs
	# 	to this calendar occurs, Picker url
	# 	(url: '$BASTURL/notifications') will receive
	# 	a post request from google.
	# RETURN
	# 	Result of making HTTP POST request to google
	# 	establish the channel, should not matter.
	# 	'result.resourceId' is saved to our database
	# 	for unwatch purpose used in re init or wipe.
	# 	
	'calendars.watch': (calendarId) ->

		new SimpleSchema
			calendarId: type: String
		.validate
			calendarId: calendarId

		future = new Future()

		calendar = Calendars.findOne id: calendarId

		Meteor.call 'calendars.unwatch', calendarId if calendar.resourceId?

		data = 
			id: calendar._id
			address: 'https://www.loopcowstudio.com/notifications'
			type: 'web_hook'
		url = "/calendar/v3/calendars/#{calendarId}/events/watch"

		GoogleApi.post url, data: data,
			(error, result) ->
				if error
					future.throw parseError error
				else
					Calendars.update id: calendarId,
						$set: resourceId: result.resourceId,
						null,
						(error) ->
							if error
								future.throw parseError error
							else
								future.return result

		future.wait()


	# !!!
	# 	SHOULD NOT BE CALLED MANUALLY!
	# 	IT WILL AUTOMATICALLY EXECUTES ON WATCH 
	# 	TO MAKE SURE NO DUPICATIONS (NOT GOING
	# 	TO SUCCEED ANYWAY).
	# DESCRIPTION
	# 	Unwatch a calendar which means drop the
	# 	channel between our server and google so
	# 	we will not receive post notification from
	# 	google whenever there is a change on events
	# 	associated with this calendarId.
	# RETURN
	# 	Result of making HTTP POST request to google
	# 	establish the channel, should not matter.
	# 	If successfully stopped watching a calendar,
	# 	null should be returned.
	# 	
	'calendars.unwatch': (calendarId) ->

		new SimpleSchema
			calendarId: type: String
		.validate
			calendarId: calendarId

		future = new Future()

		calendar = Calendars.findOne id: calendarId

		data = 
			id: calendar._id
			resourceId: calendar.resourceId
		url = '/calendar/v3/channels/stop'

		GoogleApi.post url, data: data,
			(error, result) ->
				if error
					future.throw parseError error
				else
					future.return result
					
		future.wait()