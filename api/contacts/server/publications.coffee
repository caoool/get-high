Meteor.publish 'contacts.owner', ->
	return @ready() if !@userId?
	Contacts.find createdBy: @userId