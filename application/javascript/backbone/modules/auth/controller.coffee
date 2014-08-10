@Paperboard.module "Auth", (Auth, App, Backbone, Marionette, $, _) ->

  Auth.Router = Marionette.AppRouter.extend
    routes:
      "login" : "showLogin"

    showLogin: ->
      App.navigate(App.rootRoute, true) if App.user
      App.content.show new Auth.Login.View

  App.addInitializer ->
    new Auth.Router