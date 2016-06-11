# @Users = {}

# Users.profileSchema = new SimpleSchema
# 	school:
# 		type: String
# 		optional: true

# Users.schema = new SimpleSchema
# 	username:
# 		type: String
# 		# For accounts-password, either emails or username is required, but not both. It is OK to make this
# 		# optional here because the accounts-password package does its own validation.
# 		# Third-party login packages may not require either. Adjust this schema as necessary for your usage.
# 		optional: true
# 	emails:
# 		type: Array
# 		# For accounts-password, either emails or username is required, but not both. It is OK to make this
# 		# optional here because the accounts-password package does its own validation.
# 		# Third-party login packages may not require either. Adjust this schema as necessary for your usage.
# 	  optional: true
# 	"emails.$":
# 		type: Object
# 		optional: true
# 	"emails.$.address":
# 		type: String
# 		regEx: SimpleSchema.RegEx.Email
# 		optional: true
# 	"emails.$.verified":
# 		type: Boolean
# 		optional: true
# 	# Use this registered_emails field if you are using splendido:meteor-accounts-emails-field / splendido:meteor-accounts-meld
# 	registered_emails:
# 		type: [Object]
# 		optional: true
# 		blackbox: true
# 	createdAt:
# 		type: Date
# 	profile:
# 		type: Users.profileSchema
# 		optional: true
# 	# Make sure this services field is in your schema if you're using any of the accounts packages
# 	services:
# 		type: Object
# 		optional: true
# 		blackbox: true
# 	# In order to avoid an 'Exception in setInterval callback' from Meteor
# 	heartbeat:
# 		type: Date
# 		optional: true

# Meteor.users.attachSchema Users.schema