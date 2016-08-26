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
		optional: true
	etag:
		type: String
		optional: true
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
	attendees:
		type: [Object]
		optional: true
	'attendees.$.email':
		type: String
	'attendees.$.displayName':
		type: String
		optional: true
	'attendees.$.organizer':
		type: Boolean
		optional: true
	'attendees.$.responseStatus':
		type: String
		allowedValues: [
			'needsAction'
			'declined'
			'tentative'
			'accepted'
		]
	# DESCRIPTION
	# 	localAttendees is used to save local attendees.
	# 	That means not from google but resides on our
	# 	own database.
	localAttendees:
		type: [Object]
		optional: true
	'localAttendees.$.phoneNumber':
		type: String
	'localAttendees.$.displayName':
		type: String
		optional: true
	'localAttendees.$.responseStatus':
		type: String
		allowedValues: [
			'needsAction'
			'declined'
			'tentative'
			'accepted'
		]
		defaultValue: 'needsAction'
	'localAttendees.$.userId':
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
	source:
		type: String
		allowedValues: [
			'ShoutOut'
			'Google'
			'Facebook'
		]
	calendarId:
		type: String
		optional: true
	school:
		type: String
	club:
		type: String
		optional: true
	tags:
		type: [String]
		optional: true
	createdBy:
		type: String
		autoValue: ->
			if @isInsert
				if @userId?
					@userId
				else
					@insert
			else @unset()
	createdAt:
		type: Date
		autoValue: ->
			if @isInsert
				new Date
			else if @isUpsert
				$setOnInsert: new Date
			else @unset()

Events.attachSchema Events.schema

Events.parse = (item) ->
	if item? and item.start? and item.start.date?
		item.start = item.start.date
	else if item? and item.start? and item.start.dateTime?
		item.start = item.start.dateTime
	if item? and item.end? and item.end.date?
		item.end = item.end.date
	else if item? and item.start? and item.end.dateTime?
		item.end = item.end.dateTime
	item

Events.init = (calendar, items) ->
	Events.remove calendarId: calendar.id
	for item in items
		item.calendarId = calendar.id
		item.source = calendar.source
		item.school = calendar.school
		item.club = calendar.club
		item.tags = calendar.tags
		item = Events.parse item
		continue if item.creator.email != Meteor.user().services.google.email
		Events.insert item

Events.sync = (calendarId, items) ->
	for item in items
		item.calendarId = calendarId
		calendar = Calendars.findOne id: calendarId
		item.source = 'Google'
		item.school = calendar.school
		item.club = calendar.club
		item.tags = calendar.tags
		item.createdBy = calendar.createdBy
		item = Events.parse item
		if item.status == 'cancelled'
			Events.remove id: item.id
		else if item.status == 'confirmed'
			if Events.findOne(id: item.id)?
				Events.update {id: item.id}, $set: item
				if !item.attendees?
					Events.update {id: item.id}, $unset: attendees: 1
			else Events.insert item

Events.parse.facebook = (item) ->
	item.summary = item.name
	item.start = item.start_time
	item.end = item.end_time
	item.visibility = item.type
	item.location = item.place.name if item.place? and item.place.name?
	item

Events.import = {}
Events.import.facebook = (items, club=null, tags=null) ->
	Events.remove
		source: 'Facebook'
		createdBy: Meteor.userId()
	items = items.filter (item) -> item.is_viewer_admin?
	for item in items
		item.source = 'Facebook'
		item.school = Meteor.user().profile.school
		item.club = club if club?
		item.tags = tags if tags?
		item = Events.parse.facebook item
		Events.insert item

Events.sync.facebook = (items, club=null, tags=null) ->
	items = items.filter (item) -> item.is_viewer_admin?
	for item in items
		item.source = 'Facebook'
		item.school = Meteor.user().profile.school
		item.club = club if club?
		item.tags = tags if tags?
		item = Events.parse.facebook item
		_event = Events.findOne id: item.id
		Events.insert item if !_event?

