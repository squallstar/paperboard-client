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

      $(event.currentTarget).parent().removeClass 'with-error'

      if event.which is 13
        do event.preventDefault
        return @doSignup event

    checkEmail: (event) ->
      email = @ui.email.val()

      if not App.Helpers.RegExps.isValidEmail email
        return @ui.email.parent().removeClass('with-success').addClass('with-error').find('span').text 'The email address is not valid'
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
      return if @requesting

      if event then do event.preventDefault

      @$el.find('.with-error').removeClass 'with-error'

      full_name = @ui.full_name.val()

      if full_name.length < 3
        @ui.full_name.parent().addClass('with-error').find('span').text 'Are you sure this is your real name?'
        return @ui.full_name.select()

      email = @ui.email.val()

      unless App.Helpers.RegExps.isValidEmail email
        @ui.email.parent().addClass('with-error').find('span').text 'The email address is not valid'
        return @ui.email.select()

      pwd = @ui.password.val()

      if pwd.length < 5
        @ui.password.parent().addClass('with-error').find('span').text 'The password needs to be at least 6 characters'
        return @ui.password.select()

      if pwd.length > 32
        @ui.password.parent().addClass('with-error').find('span').text 'The password is too long'
        return @ui.password.select()

      pwd2 = @ui.confirm_password.val()

      unless pwd is pwd2
        @ui.confirm_password.parent().addClass('with-error').find('span').text 'The confirmation password doesn\'t match'
        return @ui.confirm_password.select()

      $fields = @$el.find 'input'
      $fields.attr 'readonly', true

      @requesting = true

      Backbone.OAuth.post
        method: 'POST'
        url: '/v3/sign_up'
        data:
          user:
            full_name: full_name
            email: email
            password: pwd
            password_confirmation: pwd2

        success: (data) =>
          @requesting = false
          App.setToken data.auth_token
          App.request "set:user", data.user
          App.navigate 'get-started', {trigger: true, replace: true}

        error: (response) =>
          @requesting = false
          alert response.responseJSON.errors[0]
          $fields.removeAttr 'readonly'

    onDomRefresh: ->
      @ui.full_name.focus()
      App.$html.addClass 'frms-signup'

    onDestroy: ->
      App.$html.removeClass 'frms-signup'