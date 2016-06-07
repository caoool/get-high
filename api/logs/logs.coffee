@Logs = new Mongo.Collection 'logs'

if Meteor.isServer
	Logs._ensureIndex { 'date': 1 }, { expireAfterSeconds: 86400 }

Logs.deny
	insert: -> true
	update: -> true
	remove: -> true

Logs.schema = new SimpleSchema
  message:
    type: String
    label: 'The contents of this log message.'
  createdAt:
	  type: Date
	  label: 'The date and time when this log item occurred.'
	  autoValue: ->
	      if @isInsert
	        new Date
	      else if @isUpsert
	        $setOnInsert: new Date
	      else @unset()

Logs.attachSchema Logs.schema

Logs.log = (message) ->
	if Meteor.isServer
		Logs.insert message: message, ->
			console.log "#{message} (logged)"
