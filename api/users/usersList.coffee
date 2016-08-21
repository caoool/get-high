class UsersListCollection extends Mongo.Collection

@UsersList = new UsersListCollection 'usersList'

UsersList.deny
	insert: -> true
	update: -> true
	remove: -> true

UsersList.schema = new SimpleSchema
	userId:
		type: String
	name:
		type: String
		optional: true
	picture:
		type: String
		optional: true
	phoneNumber:
		type: String
		optional: true
	googleEmail:
		type: String
		optional: true
	facebookEmail:
		type: String
		optional: true
	createdAt:
		type: Date
		autoValue: ->
			if @isInsert
				new Date
			else if @isUpsert
				$setOnInsert: new Date
			else @unset()

UsersList.attachSchema UsersList.schema