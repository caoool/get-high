class CalendarsCollection extends Mongo.Collection
	# DESCRIPTION:
	# 	Insert hook will check exisitng google calendar
	# 	and associated event in database. If duplicates
	# 	are found, remove them before inserting.
	insert: (calendar, events, callback) ->
		Calendars.remove id: calendar.id
		Events.init calendar, events
		super calendar, callback

	# DESCRIPTION
	# 	Only applies to 'calendar.sync' with events passing
	# 	as a parameter
	update: (selector, modifier, events=null, callback) ->
		Events.sync selector.id, events if events?
		super selector, modifier, callback

@Calendars = new CalendarsCollection 'calendars'

Calendars.deny
	insert: -> true
	update: -> true
	remove: -> true

Calendars.schema = new SimpleSchema
	### From Google ###
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
	###*
	 * Unique Id that defines google notification channel.
	 * @type {String}
	###
	resourceId:
		type: String
		optional: true
	# From us
	school:
		type: String
	###*
	 * Store's the name of the club.
	 * Automatically pulled from summary from google.
	 * Can be manually updated later.
	 * @type {String}
	###
	club:
		type: String
	tags:
		type: [String]
		optional: true
	createdBy:
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

###*
 * Filter our calendars with accessRole: reader (not owned by user)
 * and only keeps the ones with accessRole: owner.
 * @param  {JSON} calendars List of all calendars
 * @return {Array}					Filtered list of calendars
###
Calendars.filter = (calendars) ->
	calendars.filter (calendar) -> calendar.accessRole == 'owner'