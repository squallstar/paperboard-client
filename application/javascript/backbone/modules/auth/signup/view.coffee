@Paperboard.module "Auth.Signup", (Signup, App, Backbone, Marionette, $, _) ->

  Signup.View = Marionette.ItemView.extend
    template: "signup"
    className: "window"

    ui:
      full_name: "input.full_name"
      email: "input.email"
      password: "input.password"

    keyUp: (e) ->
      if e.which is 13 then 1

    doLogin: (event) ->
      if event then do event.preventDefault

      Backbone.OAuth.post
        method: 'POST'
        url: App.url '/v3/sign_up'
        # data:
        #   user:
        #     email: @email
        #     password: @password
        # success: (data) ->
        #   App.setToken data.auth_token
        #   App.request "set:user", data.user
        #   App.navigate App.rootRoute, true
        # error: ->
        #   alert 'The e-mail address or password you entered is not valid.'
      false

    onDomRefresh: ->
      @ui.full_name.focus()