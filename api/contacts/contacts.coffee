class contactsCollection extends Mongo.Collection

@Contacts = new contactsCollection 'contacts'

Contacts.deny
	insert: -> true
	update: -> true
	remove: -> true

Contacts.schema = new SimpleSchema
	# DESCRIPTION
	# 	If contact is registered in our system,
	# 	the user id is just his user._id.
	# 	Null otherwise.
	userId:
		type: String
		optional: true
	createdBy:
		type: String
		autoValue: ->
			if @isInsert
				@userId
			else if @isUpsert
				$setOnInsert: @userId
			else @insert
	createdAt:
		type: Date
		autoValue: ->
			if @isInsert
				new Date
			else if @isUpsert
				$setOnInsert: new Date
			else @unset()
	updatedAt:
		type: Date
		autoValue: ->
			if @isUpdate
				new Date
		denyInsert: true
		optional: true

Contacts.attachSchema Contacts.schema