class EventsCollection extends Mongo.Collection
	# DESCRIPTION:
	insert: (event, callback) ->
		super event, callback

	update: (selector, modifier, callback) ->
		super selector, modifier, callback

	remove: (selector, callback) ->
		super selector, callback

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
		optional: true
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

Events.parseDate = (item) ->
	if item? and item.start? and item.start.date?
		item.start = item.start.date
	else if item? and item.start? and item.start.dateTime?
		item.start = item.start.dateTime
	if item? and item.end? and item.end.date?
		item.end = item.end.date
	else if item? and item.start? and item.end.dateTime?
		item.end = item.end.dateTime
	item

Events.init = (calendarId, items) ->
	Events.remove calendarId: calendarId
	for item in items
		item.calendarId = calendarId
		item = Events.parseDate item
		Events.insert item

Events.sync = (calendarId, items) ->
	for item in items
		item.calendarId = calendarId
		item = Events.parseDate item
		if item.status == 'cancelled'
			Events.remove id: item.id
		else if item.status == 'confirmed'
			if Events.findOne(id: item.id)?
				Events.update {id: item.id}, $set: item
			else Events.insert item