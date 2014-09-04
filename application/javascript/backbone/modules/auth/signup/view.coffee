@Paperboard.module "Auth.Signup", (Signup, App, Backbone, Marionette, $, _) ->

  Signup.View = Marionette.ItemView.extend
    template: "signup"
    className: "frms"

    ui:
      full_name: "input.full_name"
      email: "input.email"
      password: "input.password"
      confirm_password: "input.confirm_password"

    events:
      "keyup input" : "keyUp"
      "click .btn-signup" : "doSignup"
      "blur input.email" : "checkEmail"

    keyUp: (event) ->
      $el = $ event.currentTarget

      if event.which is 13
        do event.preventDefault
        if $el.is @ui.full_name
          @ui.email.focus()
        else
          @doSignup event

      else if $el.is @ui.email
        if @ts then clearTimeout @ts
        @ts = setTimeout =>
          do @checkEmail
        , 350

    checkEmail: (event) ->
      return if event and @ui.email.parent().hasClass 'with-success'

      email = @ui.email.val()
      return unless email
      if event
        return if email.indexOf('@') isnt -1 and email.indexOf('.') isnt -1

      unless App.Helpers.RegExps.isValidEmail email
        return @ui.email.parent().removeClass('with-success').addClass 'with-error'
      else
        @ui.email.parent().removeClass 'with-error with-success'

      Backbone.OAuth.post
        url: '/v3/user/check_email'
        data:
          email: email
        success: (data) =>
          @ui.email.parent().addClass 'with-success'
        error: (response) =>
          @ui.email.parent().addClass('with-error').find('span').text response.responseJSON.errors[0]

    doSignup: (event) ->
      if event then do event.preventDefault

      @$el.find('.with-error').removeClass 'with-error'

      full_name = @ui.full_name.val()

      if full_name < 3
        @ui.full_name.parent().addClass 'with-error'
        return @ui.full_name.select()

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
        url: '/v3/sign_up'
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