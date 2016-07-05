# get-high

Project name is subject to change.  
Somebody edit this README.  

## API Playground

###[API Playground (Document)](https://loopcowstudio.com)
Can be used to test and explore some of the APIs.

~~[Logger](https://loopcowstudio.com/logger) can be used to track server connections in real time for a better testing purpose. *more logs can ben added upon requests*~~

###[Logs](https://github.com/arunoda/meteor-up#access-logs) by [Meteor up](https://github.com/arunoda/meteor-up)
Logs can be accessed by running ```mupx logs -f``` in the terminal within the working folder.

###[Kadira online debugger](https://ui.kadira.io/apps/WjerWJuJ9dn7Atjb4/dashboard/overview)
We are using [kadira](https://ui.kadira.io/) services to deal with logging and real time debugging. Follow the instructions on how to use it, and it can be really helpful.  
> Please be sure to ask me to add you as a collaborator or you will not be able to see.  
> My email address: caooolu@outlook.com  
*I am paying 50 bucks / month for it right now (lowest rate)*  
> Debug connect *https://www.loopcowstudio.com*  
> Debug Auth Key *gethighdebugbughighgetbuggethighohhahahasooooohighhigh*  

## Code Style and Conventions

Please follow the [Git commit message conventions](http://chris.beams.io/posts/git-commit/) for better unified developing experiences.

## Technology and Platform

[Meteor](https://www.meteor.com/) is a full-stack NodeJS platform that can be used to build both front-end and back-end web-apps as well as mobile apps (through [Cordova](https://cordova.apache.org/)). Before the release of version 1.3, it is recommend to write **front-end templates with Blaze** (provided by meteor). With the 1.3 upgrade, meteor now supports **Angular and React natively**, ionic (web technologies on mobile apps) works natively with angular.

**Here we will only use it for back-end services** because later on our web app can be easily adopted with the same codebase.

[DDP](https://github.com/meteor/meteor/blob/devel/packages/ddp/DDP.md) is a protocol between a lient and a server that uses either SockJS or WebSockets as a lower-level message transport. DDP messages are JSON objects.

**We will use DDP for client server communication** since its native for meteor and really easy to implement.

## Tutorials and Docs to read

###Please take some time to read and understand the following information before contributing.

~~[AngularJS](http://www.w3schools.com/angular/default.asp) - angular tutorial on w3cshools~~

~~[Ionic Crash Course](https://www.youtube.com/watch?v=C-UwOWB9Io4&feature=youtu.be) - short video introduction of ionic on youtube~~

~~[Todo App](https://www.meteor.com/tutorials/angular/creating-an-app) - basic meteor tutorial _(other versions available: blaze, react. focus on Angular version)_~~

~~[Whatsapp Clone](http://www.angular-meteor.com/tutorials/whatsapp/meteor/bootstrapping) - basic meteor mobile app tutorial using meteor + angular + ionic + cordova~~

[METEOR::Todo App](https://www.meteor.com/tutorials/angular/creating-an-app) - basic meteor tutorial gives picture of how meteor works _your choice to read or not_

[METEOR::Meteor Guide](http://guide.meteor.com/) - focus on DATA section since clients will call meteor methods on server or subscribe collection(data) from it _your choice to read or not_

[METEOR::DDP](https://github.com/meteor/meteor/blob/devel/packages/ddp/DDP.md) - DDP library repository _your choice to read or not_

[METEOR::Android-DDP](https://github.com/kenyee/android-ddp-client) or

[METEOR::Android-DDP-Client](https://github.com/kenyee/android-ddp-client) - two DDP client library for android, use either one

[METEOR::SwiftDDP](https://github.com/siegesmund/swiftddp) - an iOS DDP client library, use it on iOS front-end application

[GOOGLE::OAuth2.0](https://developers.google.com/identity/protocols/OAuth2) - authentication and authorization to use google apis

[GOOGLE::CalendarAPI](https://developers.google.com/google-apps/calendar/) - most of functions will be implemented on our server as an additional layer, still knowledges of basics are required

[FACEBOOK::getting list of events from page](https://developers.facebook.com/docs/graph-api/reference/page/events/)

[FACEBOOK::Events Details ](https://developers.facebook.com/docs/graph-api/reference/event/)

... more on the way

## Configurations

**CRITICAL** configurations need to be established before clients can be connected!!

SERVER ADDRESS: wss://www.loopcowstudio.com  
SSL: true  

### Google

#### Scope (Permission)
List can be found [here](https://developers.google.com/identity/protocols/googlescopes)
* email
* contact
* CalenderAPI
* offlineToken
*Demostration of how to configure can be found under demo project iOS below.*

#### Client Credentials
> CLIENT_ID ~> '22026107675-jfeoijhr5qlpvds0v0dtlvpsv8njsioq.apps.googleusercontent.com'

### Clients Demos

#### iOS
iOS client is implemented with SwiftDDP installed through cocoapods including some fixes and modification specific for our application.  
[Please refer to his repository](https://github.com/caoool/DDPTest)

### Login Guide
Here I will brief explain the abstract login process on mobile native clients as well as providing some sample codes to follow.  
Please read carefully and understand the process or it will always causes trouble later on.  

#### Procedures:
1. Aquire google oauth token and secret following [GOOGLE::OAuth2.0](https://developers.google.com/identity/protocols/OAuth2).  
2. Signin on our server by calling 'login' methods with aquired token and secret.  
3. Save the token returned from callback result of above function.  
4. Use this token to log the user in next time (app startup) such like app relaunch and so on.  

#### Detail:
> For actual implemenetation [Please refer to his repository](https://github.com/caoool/DDPTest)

1. Aquire google oauth token and secret following [GOOGLE::OAuth2.0](https://developers.google.com/identity/protocols/OAuth2).  
	1. Follow the common OAuth guide and establish a webview redirecting to google oauth url.
	2. Inject JS code and if getElementById('config') is found, check if 'credentialSecret' and 'credentialToken' exist as String.
	3. Be sure to include calendar and email scope as well as offline token.
	4. Sample Code (Swift)
	~>
	```Swift
	public static func google(clientId: String) -> String {

      let token = randomBase64String()
      let httpUrl = MeteorOAuth.httpUrl
      let redirect = "\(httpUrl)/_oauth/google"
      let state = MeteorOAuth.stateParam(token, redirectUrl: redirect)

      // Added by Lu
      let scope = "email+https://www.googleapis.com/auth/calendar"
      // End

      var url = "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=\(clientId)"

      // Added by Lu
      url += "&approval_prompt=force"
      url += "&access_type=offline"
      // End

      url += "&redirect_uri=\(redirect)"
      url += "&scope=\(scope)"
      url += "&state=\(state)"

      return url
  }
  ```
  * This will be used to generate the OAuth url *

2. Signin on our server by calling 'login' methods with aquired token and secret.  
	1. If found the above 2 values, save it and use it to login to our server (also close the webview).
	2. Sample Code (Swift)
	~> SwiftDDP/MeteorOAuthViewController.swift
	```Swift
	webView.evaluateJavaScript("JSON.parse(document.getElementById('config').innerHTML)",
      completionHandler: { (html: AnyObject?, error: NSError?) in
          if let json = html {
              if let secret = json["credentialSecret"] as? String,
                  token = json["credentialToken"] as? String {
                      webView.stopLoading() // Is there a possible race condition here?
                      self.signIn(token, secret: secret)
              }
          } else {
              print("There was no json here")
          }
          
          // TODO: What if there's an error?, if the login fails
  })
	```

3. Save the token returned from callback result of above function.  
	1. ```self.signIn``` here is just calling method 'login'.
	2. Be sure to save the token inside the result of the above method call's callback, we will use it to login the next time **BYPASS GOOGLE API**.
	3. Sample Code (Swift)
	~> SwiftDDP/MeteorOAuthViewController.swift
	```Swift
	func signIn(token: String, secret: String) {
      let params = ["oauth":["credentialToken": token, "credentialSecret": secret]]
      // This is just making 'login' method call
      Meteor.client.login(params) { result, error in
          print("Meteor login attempt \(result), \(error)")
          self.close()
      }
  }

  // Meteor.client.login
  public func login(params: NSDictionary, callback: ((result: AnyObject?, error: DDPError?) -> ())?) {
    method("login", params: NSArray(arrayLiteral: params)) { result, error in
    // ...
    }
  }
  ```

4. Use this token to log the user in next time (app startup) such like app relaunch and so on.  
	1. Token will be returned in the above method call Meteor.client.login, save it locally persistently.
	2. On app startup or relaunch, login the user use this token and 'login' method with ```params: "resume": token```.
	3. Sample Code (Swift)  
	~> SwiftDDP/DDPExtensions.swift
	```Swift
	public func loginWithToken(callback: DDPMethodCallback?) -> Bool {
      if let token = userData.stringForKey(DDP_TOKEN),
          let tokenDate = userData.objectForKey(DDP_TOKEN_EXPIRES) {
              print("Found token & token expires \(token), \(tokenDate)")
              if (tokenDate.compare(NSDate()) == NSComparisonResult.OrderedDescending) {
                  let params = ["resume":token] as NSDictionary

                  // This login here is the same as above Meteor.client.login
                  login(params, callback:callback)
                  return true
              }
      }
      return false
  }
	```

