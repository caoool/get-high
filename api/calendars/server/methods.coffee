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
	# 	the current user.
	# RETURN:
	# 	items: []
	# 	-> id, summary, description
	'calendars.list': ->
		future = new Future()
		url = '/calendar/v3/users/me/calendarList'
		options = params: fields: 'items(id,summary,description)'
		GoogleApi.get url, options,
			(error, result) ->
				if error
					future.return throwError()
				else
					future.return result
		future.wait()

	# !!!
	# 	WIPE! ONLY INIT ON CREATION OR BROKEN!
	# DESCRIPTION:
	# 	Init will wipe the current calendar stored in
	# 	our database and clear all the events belongs
	# 	to it.
	# RETURN:
	# 	<check yourself, or someone write it>
	'calendars.init': (calendarId) ->
		future = new Future()
		url = "/calendar/v3/calendars/#{calendarId}/events"
		options = params: fields: fields
		Logs.log "...CALLING...METHOD:: calendars.init >>> Google API:: GET #{url}"
		GoogleApi.get url, options,
			(error, result) ->
				if error
					Logs.log '...END...ERROR:: call failed'
					future.return throwError error
				else
					result.id = calendarId
					Calendars.insert result,
						(error, calendar_id) ->
							if error
								Logs.log '...END...ERROR:: calendar insertion failed'
								future.return throwError error
							else
								Logs.log '...END...SUCCESS:: calendar initialized'
								future.return "#{calendar_id} #{result}"
		future.wait()

	# DESCRIPTION:
	# 	
	'calendars.sync': (calendarId, calendar_id) ->
		future = new Future()
		calendar = Calendars.findOne _id: calendar_id
		if calendar?
			url = "/calendar/v3/calendars/#{calendarId}/events"
			options = params:
				syncToken: calendar.nextSyncToken
				fields: fields
			Logs.log "...CALLING...METHOD:: calendars.sync >>> Google API:: GET #{url}"
			GoogleApi.get url, options,
				(error, result) ->
					if error
						Logs.log '...END...ERROR:: call failed'
						future.return throwError()
					else if result.etag == calendar.etag
						Logs.log '...END...SUCCESS:: no changes have been made to calendar'
						future.return "no changes since last sync"
					else
						Calendars.update calendar_id, $set: result,
							(error) ->
								if error
									Logs.log '...END...ERROR:: calendar update failed'
									future.return throwError error
								else
									Logs.log '...END...SUCCESS:: found changes, calendar updated'
									future.return "found changes, calendar updated"
		else
			future.return 'Calendar not found, please check your input or init first'
		future.wait()
