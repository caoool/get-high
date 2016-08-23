Meteor.methods


	'conn.test': (client = null) ->
		
		if Meteor.isServer
			Logs.log "...DDP...METHOD:: conn.text >>> connection established from CLIENT:#{client}"
		result = "Connection for #{client} established"

	'testGraph': ->
		if Meteor.isServer
			FBGraph.setAccessToken Meteor.user().services.facebook.accessToken
			wrap = Meteor.wrapAsync FBGraph.get
			result = wrap 'me?fields=picture'
			console.log result.picture.data.url

