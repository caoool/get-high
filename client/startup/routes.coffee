FlowRouter.route '/',
  action: ->
    BlazeLayout.render 'apiPlayground'

FlowRouter.route '/logger',
	action: ->
		BlazeLayout.render 'logger'