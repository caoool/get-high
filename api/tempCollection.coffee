class TempCollection extends Mongo.Collection

@Temps = new TempCollection 'temps'

Temps.schema = new SimpleSchema
	summary:
		type: String

Temps.attachSchema Temps.schema

Meteor.publish 'temps', ->
	Logs.log '...DDP...SUB:: temps >> subscribing'
	Temps.find()