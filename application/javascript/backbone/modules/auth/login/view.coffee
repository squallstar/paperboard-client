@Paperboard.module "Auth.Login", (Login, App, Backbone, Marionette, $, _) ->

  Login.View = Marionette.ItemView.extend
    template: "login"
    className: "window"

    events:
      "click .btn-login": "doLogin"
      "submit form": "doLogin"
      "click .forgot-password": "showForgotPassword"
      "keyup input.email, input.password": "keyUp"

    ui:
      email: "input.email"
      password: "input.password"

    showForgotPassword: (event) ->
      do event.preventDefault
      App.navigate "forgot-password", trigger: true

    keyUp: (e) ->
      if e.which is 13
        @doLogin()

    doLogin: (event) ->
      if event then do event.preventDefault

      @email = @ui.email.val()
      if not @email then return @ui.email.focus()

      @password = @ui.password.val()
      if not @password then return @ui.password.focus()

      @ui.email.blur()
      @ui.password.blur()

      Backbone.OAuth.post
        method: 'POST'
        url: App.url '/v3/sign_in'
        data:
          user:
            email: @email
            password: @password
        success: (data) ->
          App.setToken data.auth_token
          App.request "set:user", data.user
          App.navigate App.rootRoute, true
        error: ->
          alert 'The e-mail address or password you entered is not valid.'
      false

    onDomRefresh: ->
      @ui.email.focus()