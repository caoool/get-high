class CalendarsCollection extends Mongo.Collection
	# insert: (calendar, callback) ->
	# 	_calendar.id = calendar.id
	# 	_calendar.etag = calendar.etag
	# 	_calendar.summary = calendar.summary
	# 	_calendar.description = calendar.description
	# 	_calendar.nextSyncToken = calendar.nextSyncToken
	# 	super _calendar, callback

@Calendars = new CalendarsCollection 'calendars'

Calendars.deny
	insert: -> true
	update: -> true
	remove: -> true

Calendars.schema = new SimpleSchema
	# Information generated by ourself.
	id:
		type: String
		label: 'The id of the calendar from google api.'
	etag:
		type: String
		label: 'The etag used to detect if any changes since last sync.'
	summary:
		type: String
		label: 'The summary of the calendar from google api.'
	description:
		type: String
		optional: true
		label: 'The description of the calendar. (Optional)'
	nextSyncToken:
		type: String
		label: 'The token used to sync new items since last sync.'
	# Information generated by ourself.
	school:
		type: String
		defaultValue: 'SCU'
		label: 'The school name of the calendar belongs to.'
	createBy:
		type: String
		label: 'The user who initialized this calendar.'
		autoValue: ->
			if @isInsert
				@userId
			else if @isUpsert
				$setOnInsert: @userId
			else @insert
	createdAt:
		type: Date
		label: 'The date and time when this calendar is first imported.'
		autoValue: ->
			if @isInsert
				new Date
			else if @isUpsert
				$setOnInsert: new Date
			else @unset()

Calendars.attachSchema Calendars.schema


