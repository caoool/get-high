Meteor.methods
	# !!!
	# 	THIS IS NOT FOR CLIENTS, DO NOT CALL
	# 	THIS METHOD ON CLIENTS!!!
	# 	MANUAL DEFINITION REQUIRED FOR EACH
	# 	SCHOOL!!!
	# DESCRIPTION
	# 	Define a tag list to a specific school.
	# 	One school only has one tag list.
	# PARAMETERS
	# 	{String} school
	# 	{[Object]} tags
	# 		{String} category
	# 		{[String]} tags
	'tags.define': (school, tags) ->
		Tags.upsert {school: school},
			$set:
				school: school
				tags: tags

	# DESCRIPTION
	# 	Get the tag list that is defined for
	# 	a given school as a JSON object.
	# PARAMETERS
	# 	{String} school
	# RETURN
	# 	{Object} tag
	# 		{String} school
	# 		{Object} tags
	# 			{String} category
	# 			{[String]} tags
	'tags.school': (school) ->
		Tags.findOne school: school

	# DESCRIPTION
	# 	Get the tag list that belongs to the
	# 	school of the current logged in user.
	# RETURN
	# 	{Object} tag
	# 		{String} school
	# 		{Object} tags
	# 			{String} category
	# 			{[String]} tags
	'tags.user': ->
		return 'not logged in' if !@userId?
		user = Meteor.users.findOne @userId
		Tags.findOne school: user.profile.school

	

