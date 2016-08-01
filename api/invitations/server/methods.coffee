Meteor.methods

	
	# DESCRIPTION
	# 	Invite user to join our app by sending
	# 	SMS messages using Twilio services.
	# FIXME
	# 	Someone has to edit the content of the
	# 	invitation.
	# 
	'invitations.app.sms': (phoneNumber) ->

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

		future.wait()

	# DESCRIPTION
	# 	Invite user to an event by sending SMS
	# 	messages using Twilio services.
	# FIXME
	# 	Someone needs to edit contents of the
	# 	actual invitation.
	# 	
	'invitations.event.sms': (eventId, phoneNumber) ->

		new SimpleSchema
			eventId: type: String
			phoneNumber: type: String
		.validate
			eventId: eventId
			phoneNumber: phoneNumber
		
		future = new Future()
		future.throw credentialError if !@userId?

		event = Events.findOne id: eventId
		future.throw notFoundError if !event?

		content = "#{Meteor.user().services.google.name} invites you to join this event #{event.summary} on ViteZite."

		twilio.sendSms
			to: phoneNumber
			from: TWILIO_NUMBER
			body: content
		, Meteor.bindEnvironment (error, result) ->
			if error
				future.throw error
			else
				attendee = phoneNumber: phoneNumber
				future.return Meteor.call 'attendees.localAdd', eventId, attendee

		future.wait()