Meteor.methods
	'conn.test': (client = null) ->
		if Meteor.isServer
			Logs.log "...DDP...METHOD:: conn.text >>> connection established from CLIENT:#{client}"
