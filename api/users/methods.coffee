Meteor.methods
	'users.setSchool': (school) ->
		Meteor.users.update @userId, $set: 'profile.school': school if @userId

	###*
	 * Default following all clubs, only clubs in the list are excluded.
	 * Calendar ID passed instead of actuall club name because that is
	 *   subject to change.
	 * @method
	 * @param  {[String]} clubs 'calendarId's
	 * @return {Integer} 0 or 1
	###
	'users.setExcludedClubs': (clubs) ->
		Meteor.users.update @userId, $set: 'profile.excludedClubs': clubs if @userId

	'users.setTags': (tags) ->
		Meteor.users.update @userId, $set: 'profile.tags': tags if @userId