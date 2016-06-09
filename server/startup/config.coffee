GOOGLE_CLIENT_ID = '22026107675-jfeoijhr5qlpvds0v0dtlvpsv8njsioq.apps.googleusercontent.com'
GOOGLE_SECRET = 'NNu4EBP2d7zJO28D8rmQR5uH'

Meteor.startup ->
	Accounts.loginServiceConfiguration.remove service: 'google'
	Accounts.loginServiceConfiguration.insert
		service: 'google'
		clientId: GOOGLE_CLIENT_ID
		secret: GOOGLE_SECRET