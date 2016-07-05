class UsersListCollection extends Mongo.Collection

@UsersList = new UsersListCollection 'usersList'

UsersList.deny
	insert: -> true
	update: -> true
	remove: -> true

UsersList.schema = new SimpleSchema
	userId:
		type: String
	picture:
		type: String
		optional: true
	googleEmail:
		type: String
	createdAt:
		type: Date
		autoValue: ->
			if @isInsert
				new Date
			else if @isUpsert
				$setOnInsert: new Date
			else @unset()

UsersList.attachSchema UsersList.schema