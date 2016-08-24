Meteor.methods

	'testGraph': ->
		if Meteor.isServer
			id = Meteor.user().services.facebook.id
			token = Meteor.user().services.facebook.accessToken
			FBGraph.setAccessToken(token).get "#{id}/events?fields=cover,id,end_time,description,name,is_viewer_admin,place,start_time,type",
				(error, result) ->
					if error
						console.log error
					else
						console.log result