@fromDate = ->
	today = new Date()
	today.setHours 0, 0, 0, 0
	today
	# new Date().setDate(today.getDate() - numberOfDays)