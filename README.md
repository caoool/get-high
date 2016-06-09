# get-high

Project name is subject to change.

Somebody edit this README.

## API Playground

[DEMO](https://loopcowstudio.com) can be used to test and explore some of the APIs.

[Logger](https://loopcowstudio.com/logger) can be used to track server connections in real time for a better testing purpose. *more logs can ben added upon requests*

## Code Style and Conventions

Please follow the [Git commit message conventions](http://chris.beams.io/posts/git-commit/) for better unified developing experiences.

## Technology and Platform

[Meteor](https://www.meteor.com/) is a full-stack NodeJS platform that can be used to build both front-end and back-end web-apps as well as mobile apps (through [Cordova](https://cordova.apache.org/)). Before the release of version 1.3, it is recommend to write **front-end templates with Blaze** (provided by meteor). With the 1.3 upgrade, meteor now supports **Angular and React natively**, ionic (web technologies on mobile apps) works natively with angular.

**Here we will only use it for back-end services** because later on our web app can be easily adopted with the same codebase.

[DDP](https://github.com/meteor/meteor/blob/devel/packages/ddp/DDP.md) is a protocol between a lient and a server that uses either SockJS or WebSockets as a lower-level message transport. DDP messages are JSON objects.

**We will use DDP for client server communication** since its native for meteor and really easy to implement.

## Tutorials and Docs to read

Please take some time to read and understand the following information before contributing.

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

### Google

Scope (Permission) - list can be found [here](https://developers.google.com/identity/protocols/googlescopes)
* CalenderAPI
* offlineToken

Client Credentials - need to be obtained before using google apis, credentials can be added [here](https://console.developers.google.com/apis/credentials?project=get-high) *additional app owner can be added upon requests*
