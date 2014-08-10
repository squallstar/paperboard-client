#
# Backbone OAuth plugin
# Written by Nicholas Valbusa
#

do (Backbone) ->

  Backbone.OAuth =

    #
    # Builds an authenticated URL using the base_url and the oauth_token
    #
    url: (endpoint, options = {}) ->
      throw new Error('Endpoint required') unless endpoint

      path = '/' + endpoint.replace(/^\/|\/$/g, '')

      token = do Paperboard.getToken

      return Paperboard.options.url + path unless token

      token = "auth_token=" + ( if options.token then options.token else token )
      if path.indexOf('?') is -1
        token = '?' + token
      else
        token = '&' + token

      Paperboard.options.url + path + token

    #
    # Helper to make an Ajax call with the auth_token
    #
    ajax: (options) ->
      options ?= {}
      $.ajax
        url: Backbone.OAuth.url options.url, options
        method: options.method
        dataType: options.dataType or "json"
        contentType: options.contentType
        data: options.data
        success: options.success
        error: options.error

    #
    # Makes a GET request to the api using the auth_token
    #
    get: (options) ->
      options ?= {}
      options.method = "GET"
      @ajax options

    #
    # Makes a POST request to the api using the auth_token and sending the data as a JSON object
    #
    post: (options) ->
      options ?= {}
      options.method = options.method or "POST"
      options.contentType = "application/json"
      if options.data
        options.data = JSON.stringify options.data
      @ajax options

    #
    # Extracts a param given its name and an optional url
    # When the url is not provided, it will use the document location.search attribute
    #
    getParam: (name, url) ->
      if not url then url = (if location.search then location.search else Backbone.history.search)
      decodeURIComponent (new RegExp("[?|&]" + name + "=" + "([^&;]+?)(&|#|;|$)").exec(url) or [null, ""])[1].replace(/\+/g, "%20")

    #
    # Custom OAuth sync
    #
    sync: (method, model, options = {}) ->
      # Gets the url from the model when not provided
      unless options.url
        options.url  = _.result(@, 'url')

      # Adds the API prefix (and auth token) unless the urls contains the protocol
      if options.url.indexOf('://') is -1
        options.url = Backbone.OAuth.url options.url

      # Custom error callback
      error = options.error
      options.error = (response, errorObj, description) ->

        # Unauthorized (Token not valid)
        if response.status is 401
          if Paperboard.vent? then Paperboard.vent.trigger "auth:not_valid"

        if typeof error is 'function'
          error response, errorObj, description

      Backbone.sync.apply(@,[method, model, options])

  # --------------------------------------------------------------------------

  Backbone.AuthModel = Backbone.Model.extend
    sync: Backbone.OAuth.sync

  # --------------------------------------------------------------------------

  Backbone.AuthDeepModel = Backbone.DeepModel.extend
    sync: Backbone.OAuth.sync

  # --------------------------------------------------------------------------

  Backbone.AuthCollection = Backbone.Collection.extend
    sync: Backbone.OAuth.sync