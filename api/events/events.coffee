class EventsCollection extends Mongo.Collection
	# DESCRIPTION:
	insert: (event, callback) ->
		Logs.log '...CALLING...METHOD:: calendars.init >>> event inserted'
		super event, callback

@Events = new EventsCollection 'events'

Events.deny
	insert: -> true
	update: -> true
	remove: -> true

Events.schema = new SimpleSchema
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
	start:
		type: Date
	end:
		type: Date
		optional: true
	location:
		type: String
		optional: true
	# DESCRIPTION:
	# 	Visibiilty is used to decide whether or
	# 	not this event will go public. It has 4
	# 	types corresponding to Google API
	# 	-> 'default'
	# 	-> 'public'
	# 	-> 'private'
	# 	-> 'confidential'
	visibility:
		type: String
		defaultValue: 'default'
	# From us
	calendarId:
		type: String
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

Events.attachSchema Events.schema

Events.init = (calendar_id, items) ->
	for item in items
		item.calendarId = calendar_id
		if item.start.date?
			item.start = item.start.date
		else if item.start.dateTime?
			item.start = item.start.dateTime
		if item.end.date?
			item.end = item.end.date
		else if item.end.dateTime?
			item.end = item.end.dateTime
		Events.insert item