Meteor.methods

	
	# DESCRIPTION
	# 	Invite user to join our app by sending
	# 	SMS messages using Twilio services.
	# FIXME
	# 	Someone has to edit the content of the
	# 	invitation.
	# 
	'invitations.sms': (phoneNumber) ->

		new SimpleSchema
			phoneNumber: type: String
		.validate
			phoneNumber: phoneNumber

		future = new Future()
		future.throw credentialError if !@userId?

		content = 'Please download this app and get high!'

		twilio.sendSms
			to: phoneNumber
			from: TWILIO_NUMBER
			body: content
		, (error, result) ->
			if error
				future.throw error
			else
				future.return 'SMS sent'