# !!!
# 	TAGS ARE NOT INDIVIDUAL TAGS BUT TAG
# 	LISTS THAT DEFINE ALL AVAILABLE TAGS
# 	FOR A GIVEN SCHOOL!!!
# DESCRIPTION
# 	Tags are used to define available tags
# 	belongs to a specific school. Tags can
# 	be initiated or updated by JSON files
# 	or YAML depending or your favor.

class TagsCollection extends Mongo.Collection

@Tags = new TagsCollection 'tags'

Tags.deny
	insert: -> true
	update: -> true
	remove: -> true

Tags.schema = new SimpleSchema
	school:
		type: String
	tags:
		type: [Object]
		optional: true
	'tags.$.category':
		type: String
	'tags.$.tags':
		type: [String]
		optional: true
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

Tags.attachSchema Tags.schema