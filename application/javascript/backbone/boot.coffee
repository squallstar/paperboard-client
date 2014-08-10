@Paperboard = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = "everything"

  App.$window = $('window')
  App.$html = $('html')
  App.$body = $('body')

  App.addRegions
    header:  "#header"
    sidebar: "#sidebar"
    content: "#content"
    overlay: "#overlay"

  App.$body.on "click", "a[data-navigate]", (event) ->
    do event.preventDefault
    App.navigate $(event.currentTarget).attr('html'), true

  App.vent.on "auth:not_valid", ->
    $.removeCookie '_probe_tkn'
    delete App.user
    App.navigate 'login', trigger: true

  App.setToken = (token) ->
    $.cookie '_probe_tkn', token
    App.__token = token

  App.getToken = ->
    App.__token

  App.url = (endpoint) ->
    App.options.url + endpoint

  App.on "before:start", (options) ->
    @options =
      url: options.entrypoint.replace(/^\/|\/$/g, '')

    App.__token = $.cookie '_probe_tkn'

    if options.user
      App.user = new App.Entities.User options.user

    App.boards = new App.Entities.Boards

  App.on "start", ->
    route = Backbone.history.fragment or App.rootRoute
    route = 'login' unless App.user

    if Backbone.history
      Backbone.history.start pushState: true
      @navigate(route, trigger: true) if Backbone.history.fragment is ""

  App