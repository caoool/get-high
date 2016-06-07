Meteor.publish 'logs.all', (limit = 0) ->
	Logs.find {}, {limit: limit}

Meteor.publish 'logs.fromNow', (limit = 0, now = new Date) ->
	Logs.find {createdAt: {$gt: now}}, {limit: limit}