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
	# 		
	'tags.define': (school, tags) ->

		new SimpleSchema
			school: type: String
			tags:
				type: [Object]
				optional: true
			'tags.$.category':
				type: String
			'tags.$.tags':
				type: [String]
				optional: true
		.validate
			school: school
			tags: tags

		Tags.upsert {school: school},
			$set:
				school: school
				tags: tags


	# DESCRIPTION
	# 	Get the tag list that is defined for
	# 	a given school as a JSON object.
	# 	If no school is specified it will just
	# 	return the user's school.
	# PARAMETERS
	# 	{String}? school
	# RETURN
	# 	{Object} tag
	# 		{String} school
	# 		{Object} tags
	# 			{String} category
	# 			{[String]} tags
	# 			
	'tags.school': (school=null) ->

		new SimpleSchema
			school: type: String
		.validate
			school: school

		if school?
			Tags.findOne school: school
		else
			throwError credentialError if !@userId?
			Tags.findOne school: Meteor.user().profile.school


	# DESCRIPTION
	# 	Get the tag list that belongs to the
	# 	school of the current logged in user.
	# RETURN
	# 	{Object} tag
	# 		{String} school
	# 		{Object} tags
	# 			{String} category
	# 			{[String]} tags
	# 			
	'tags.user': ->
		
		throwError credentialError if !@userId?

		tags = Tags.findOne school: Meteor.user().profile.school
		userTags = Meteor.user().profile.tags
		# client only, to omit returning error on client

		ret =
			school: Meteor.user().profile.school
			tags: []
		if tags? and userTags?
			for category in tags.tags
				_category =
					category: ''
					tags: []
				for tag in category.tags
					if tag in userTags
						_category.tags.push tag
				if _category.tags.length > 0
					_category.category = category.category
					ret.tags.push _category

			ret


	# DESCRIPTION
	# 	Return the list of all schools.
	# RETURN
	# 	{[String]} schools
	# 	
	'schools.list': ->

		schools = []
		tags = Tags.find({}, {school: 1, _id: 0}).fetch()
		for tag in tags
			schools.push tag.school
		schools