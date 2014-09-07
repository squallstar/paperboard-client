@Paperboard.module "Auth.GetStarted", (GetStarted, App, Backbone, Marionette, $, _) ->

  GetStarted.View = Marionette.ItemView.extend
    template: "get-started"
    className: "frms"

    events:
      "click .btn-continue" : "didClickContinue"

    templateHelpers: ->
      firstName: App.user.getFirstName()

    didClickContinue: (event) ->
      do event.preventDefault
      App.navigate 'connect-services', true