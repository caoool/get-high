Meteor.methods


	# DESCRIPTION
	# 	Check if the user's local phone book contacts
	# 	has registered our app or not.
	# PARAMETERS
	# 	{[String]} Phone numbers
	# RETURN
	# 	{[Boolean]} Array indications of VZ users or not
	# 	
	'contacts.checkPhoneNumbers': (phoneNumbers) ->

		new SimpleSchema
			phoneNumbers: type: [String]
		.validate
			phoneNumbers: phoneNumbers

		throwError credentialError if !@userId?

		results = []
		for phoneNumber, index in phoneNumbers
			user = UsersList.findOne phoneNumber: phoneNumber
			if user?
				results[index] = true
			else
				results[index] = false

		results