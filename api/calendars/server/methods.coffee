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
	'calendars.list': ->
		return if !Meteor.userId()?
		future = new Future()
		url = '/calendar/v3/users/me/calendarList'
		options = params: fields: 'items(id,summary,description,accessRole)'
		GoogleApi.get url, options,
			(error, result) ->
				if error
					future.return throwError()
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
	'calendars.init': (calendarId, tags=null) ->
		return if !calendarId? or calendarId == ''
		future = new Future()
		url = "/calendar/v3/calendars/#{calendarId}/events"
		options = params: fields: fields
		GoogleApi.get url, options,
			(error, result) ->
				if error
					future.return throwError error
				else
					result.id = calendarId
					result.school = Meteor.user().profile.school
					result.club = result.summary
					result.tags = tags
					Calendars.insert result, result.items,
						(error) ->
							if error
								future.return throwError error
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
	'calendars.sync': (calendarId) ->
		return if !calendarId? or calendarId == ''
		future = new Future()
		calendar = Calendars.findOne id: calendarId
		if calendar?
			url = "/calendar/v3/calendars/#{calendarId}/events"
			options = params:
				syncToken: calendar.nextSyncToken
				fields: fields
			GoogleApi.get url, options,
				(error, result) ->
					if error
						future.return throwError()
					else if result.etag == calendar.etag
						future.return "no changes since last sync"
					else
						Calendars.update {id: calendarId}, {$set: result}, result.items,
							(error) ->
								if error
									future.return throwError error
								else
									future.return result
		else
			future.return 'Calendar not found, please check your input or init first'
		future.wait()
