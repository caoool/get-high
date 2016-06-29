GOOGLE_CLIENT_ID = '22026107675-jfeoijhr5qlpvds0v0dtlvpsv8njsioq.apps.googleusercontent.com'
GOOGLE_SECRET = 'NNu4EBP2d7zJO28D8rmQR5uH'

KADIRA_APP_ID = 'WjerWJuJ9dn7Atjb4' 
KADIRA_APP_SECRET = '4fcbf34a-75ea-411b-a039-710d2a810756'

Meteor.startup ->
	Kadira.connect KADIRA_APP_ID, KADIRA_APP_SECRET
	Accounts.loginServiceConfiguration.remove service: 'google'
	Accounts.loginServiceConfiguration.insert
		service: 'google'
		clientId: GOOGLE_CLIENT_ID
		secret: GOOGLE_SECRET
		loginStyle: 'redirect'

	Temps.insert summary: '123'