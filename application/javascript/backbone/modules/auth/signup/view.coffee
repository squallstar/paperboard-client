@Paperboard.module "Auth.Signup", (Signup, App, Backbone, Marionette, $, _) ->

  Signup.View = Marionette.ItemView.extend
    template: "signup"
    className: "window"

    ui:
      full_name: "input.full_name"
      email: "input.email"
      password: "input.password"
      confirm_password: "input.confirm_password"

    events:
      "keyup input"    : "keyUp"
      "click .sign-up" : "doSignup"

    keyUp: (event) ->
      $el = $ event.currentTarget
      if event.which is 13
        do event.preventDefault
        if $el.is @ui.full_name
          @ui.email.focus()
        else
          @doSignup event


    doSignup: (event) ->
      if event then do event.preventDefault

      @$el.find('.with-error').removeClass 'with-error'

      email = @ui.email.val()

      unless App.Helpers.RegExps.isValidEmail email
        @ui.email.parent().addClass 'with-error'
        return @ui.email.select()

      pwd = @ui.password.val()

      if pwd.length < 5
        @ui.password.parent().addClass 'with-error'
        return @ui.password.select()

      if pwd.length > 32
        @ui.password.parent().addClass 'with-error'
        return @ui.password.select()

      pwd2 = @ui.confirm_password.val()

      unless pwd is pwd2
        @ui.password.parent().addClass 'with-error'
        return @ui.confirm_password.select()

      $fields = @$el.find 'input'
      $fields.attr 'readonly', true

      Backbone.OAuth.post
        method: 'POST'
        url: App.url '/v3/sign_up'
        data:
          user:
            email: @email
            password: @password
        success: (data) ->
          console.log data
          $fields.removeAttr 'readonly'
        error: (response) ->
          console.log response
          $fields.removeAttr 'readonly'

    onDomRefresh: ->
      @ui.full_name.focus()