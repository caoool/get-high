Meteor.methods
	'conn.test': (client = null) ->
		if Meteor.isServer
			Logs.log "DDP connection established from CLIENT:#{client}"
