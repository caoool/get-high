Meteor.methods


	'users.loginWithToken': (token) ->

		new SimpleSchema
			token: type: String
		.validate
			token: token

		Meteor.loginWithToken token


	'users.currentUser': ->

		throwError credentialError if !@userId?

		Meteor.users.findOne @userId


	'users.setSchool': (school) ->

		new SimpleSchema
			school: type: String
		.validate
			school: school

		throwError credentialError if !@userId?

		Meteor.users.update @userId, $set: 'profile.school': school if @userId


	'users.setName': (name) ->

		new SimpleSchema
			name: type: String
		.validate
			name: name

		throwError credentialError if !@userId?

		UsersList.update {userId: @userId}, $set: name: name
		Meteor.users.update @userId, $set: 'profile.name': name


	'users.setPicture': (picture) ->

		throwError credentialError if !@userId?

		UsersList.update {userId: @userId}, $set: picture: picture
		Meteor.users.update @userId, $set: 'profile.picture': picture


	'users.setPhoneNumber': (phoneNumber) ->

		new SimpleSchema
			phoneNumber: type: String
		.validate
			phoneNumber: phoneNumber

		throwError credentialError if !@userId?

		UsersList.update {userId: @userId}, $set: phoneNumber: phoneNumber
		Meteor.users.update @userId, $set: 'profile.phoneNumber': phoneNumber


	###*
	 * Default following all clubs, only clubs in the list are excluded.
	 * Calendar ID passed instead of actuall club name because that is
	 *   subject to change.
	 * @method
	 * @param  {[String]} clubs 'calendarId's
	 * @return {Integer} 0 or 1
	###
	'users.setExcludedClubs': (clubs) ->

		new SimpleSchema
			clubs: type: [String]
		.validate
			clubs: clubs

		throwError credentialError if !@userId?

		Meteor.users.update @userId, $set: 'profile.excludedClubs': clubs if @userId


	'users.setTags': (tags) ->

		new SimpleSchema
			tags: type: [String]
		.validate
			tags: tags

		throwError credentialError if !@userId?

		Meteor.users.update @userId, $set: 'profile.tags': tags if @userId


	'users.like': (eventId) ->

		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		Meteor.users.update @userId, $push: 'profile.likes': eventId if @userId


	'users.unlike': (eventId) ->

		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		Meteor.users.update @userId, $pull: 'profile.likes': eventId if @userId