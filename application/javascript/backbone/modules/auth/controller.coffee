@Paperboard.module "Auth", (Auth, App, Backbone, Marionette, $, _) ->

  Auth.Router = Marionette.AppRouter.extend
    routes:
      "login" : "showLogin"
      "logout" : "doLogout"
      "signup" : "showSignup"
      "get-started": "showGetStarted"
      "connect-services" : "showConnect"
      "discover" : "showDiscover"

    showLogin: ->
      return App.navigate(App.rootRoute, true) if App.user
      App.execute "hide:header"
      App.content.show new Auth.Login.View
      App.execute 'set:title', 'Login'

    showSignup: ->
      return App.navigate(App.rootRoute, true) if App.user
      App.execute "hide:header"
      App.content.show new Auth.Signup.View
      App.execute 'set:title', 'Sign up'

    showConnect: ->
      App.execute "hide:header"
      App.content.show new Auth.Connect.View
      App.execute 'set:title', 'Connect services'

    showDiscover: ->
      App.execute "hide:header"
      App.content.show new Auth.Discover.View
        collection: new App.Entities.Tags
      App.execute 'set:title', 'Discover'

    showGetStarted: ->
      App.execute "hide:header"
      App.content.show new Auth.GetStarted.View
      App.execute 'set:title', 'Get started'

    doLogout: ->
      App.user.destroy() if App.user
      App.navigate "login", {trigger: true, replace: true}

  App.addInitializer ->
    new Auth.Router