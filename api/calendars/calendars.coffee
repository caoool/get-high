class CalendarsCollection extends Mongo.Collection
	# DESCRIPTION:
	# 	Insert hook will check exisitng google calendar
	# 	and associated event in database. If duplicates
	# 	are found, remove them before inserting.
	insert: (calendar, events, callback) ->
		Calendars.remove id: calendar.id
		Events.init calendar.id, events
		super calendar, callback

	update: (selector, modifier, events, callback) ->
		Events.sync selector.id, events
		super selector, modifier, callback

@Calendars = new CalendarsCollection 'calendars'

Calendars.deny
	insert: -> true
	update: -> true
	remove: -> true

Calendars.schema = new SimpleSchema
	# From Google
	id:
		type: String
	etag:
		type: String
	summary:
		type: String
	description:
		type: String
		optional: true
	nextSyncToken:
		type: String
	# From us
	# school:
	# 	type: String
	# 	label: 'The school name of the calendar belongs to.'
	createBy:
		type: String
		autoValue: ->
			if @isInsert
				@userId
			else if @isUpsert
				$setOnInsert: @userId
			else @insert
	createdAt:
		type: Date
		autoValue: ->
			if @isInsert
				new Date
			else if @isUpsert
				$setOnInsert: new Date
			else @unset()

Calendars.attachSchema Calendars.schema