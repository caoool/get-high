Meteor.methods


	# DESCRIPTION
	# 	Get contacts from google as well as saving it locally
	# 	on our database.
	# RETURN
	# 	Does not matter (get contacts by subscription)
	# REVIEW
	# 	Google does not support sync only updates, so every
	# 	time this method being called will result in a wipe
	# 	of all contacts associated with the user.
	# 	
	'contacts.retrieve': ->

		future = new Future()
		future.throw credentialError if !@userId?

		Meteor.call 'exchangeRefreshToken', @userId
		user = Meteor.users.findOne @userId

		url = "https://www.google.com/m8/feeds/contacts/#{user.services.google.email}/full"
		Auth = 'Bearer ' + user.services.google.accessToken

		HTTP.get url, {
      params:
      	'max-results': 999
      headers: Authorization: Auth
      }, (error, result) ->
				if error
					future.throw parseError error
				else
					future.return Contacts.init user._id, result.content
					
		future.wait()