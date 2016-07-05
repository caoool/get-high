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
	title:
		type: String
		optional: true
	email:
		type: String
		optional: true
	photo:
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

Contacts.attachSchema Contacts.schema

Contacts.parse = (content) ->
	future = new Future()
	xml2js.parseString content,
		(error, result) ->
			if error
				future.return throwError error
			else
				future.return result
	future.wait()

Contacts.init = (createdBy, content) ->
	contacts = Contacts.parse(content).feed.entry
	Contacts.remove createdBy: createdBy
	contacts.forEach (contact) ->
		title = contact.title[0]._
		email = contact['gd:email'][0].$.address
		photo = contact.link[1].$.href
		user = UsersList.findOne 'googleEmail': email
		if user?
			userId = user.userId 
			photo = user.picture
		Contacts.insert
			userId: userId
			title: title
			email: email
			photo: photo
	return contacts