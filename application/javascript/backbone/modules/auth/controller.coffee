@Paperboard.module "Auth", (Auth, App, Backbone, Marionette, $, _) ->

  Auth.Router = Marionette.AppRouter.extend
    routes:
      "login" : "showLogin"
      "logout" : "doLogout"

    showLogin: ->
      return App.navigate(App.rootRoute, true) if App.user
      App.execute "hide:header"
      App.content.show new Auth.Login.View

    doLogout: ->
      App.user.destroy() if App.user
      App.navigate "login", {trigger: true, replace: true}

  App.addInitializer ->
    new Auth.Router