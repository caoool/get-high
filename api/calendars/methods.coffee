if Meteor.isServer
	Meteor.methods
		'calendars.list': ->
			future = new Future()
			url = '/calendar/v3/users/me/calendarList'
			options = params: fields: 'items(id,summary,description)'
			GoogleApi.get url, options,
				(error, result) ->
					if error then future.return throwError()
					else future.return result
			future.wait()