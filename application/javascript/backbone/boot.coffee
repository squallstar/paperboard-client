@Paperboard = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = "everything"

  App.$window = $(window)
  App.$html = $('html')
  App.$body = $('body')

  App.addRegions
    header:  "#header"
    sidebar: "#sidebar"
    content: "#content"
    overlay: "#overlay"

  App.addInitializer ->
    do @module(module).Show for module in ["Header", "Sidebar"]

  App.$window.resize ->
    grid = Math.round App.$window.width()/300
    if grid > 6 or grid < 1 then grid = 1
    return if not grid or @__gridSize is grid
    App.$html.removeClass("grid-#{@__gridSize}").addClass "grid-#{grid}"
    App.vent.trigger "change:grid", grid
    @__gridSize = grid

  App.$body.on "click", "a[data-navigate]", (event) ->
    do event.preventDefault
    App.navigate $(event.currentTarget).attr('html'), true

  App.vent.on "auth:not_valid", ->
    $.removeCookie '_probe_tkn'
    delete App.user
    App.navigate 'login', trigger: true

  App.reqres.setHandler "set:user", (user) ->
    App.user = new App.Entities.User user
    App.vent.trigger "user:login"

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
      App.request "set:user", options.user

    App.boards = new App.Entities.Boards

  App.on "start", ->
    App.$window.resize()

    route = Backbone.history.fragment or App.rootRoute
    route = 'login' unless App.user

    if Backbone.history
      Backbone.history.start pushState: true
      @navigate(route, trigger: true) if Backbone.history.fragment is ""

  App