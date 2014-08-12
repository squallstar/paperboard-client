@Paperboard = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = "everything"

  App.$window = $(window)
  App.$html = $('html')
  App.$body = $('body')

  App.addRegions
    header:  "#rg-header"
    sidebar: "#sidebar"
    content: "#content"
    overlay: "#overlay"

  App.addInitializer ->
    do @module(module).Show for module in ["Header"]

  App.$window.resize ->
    grid = Math.round App.$window.width()/300
    if grid > 6 or grid < 1 then grid = 1
    return if not grid or @__gridSize is grid
    App.$html.removeClass("grid-#{@__gridSize}").addClass "grid-#{grid}"
    App.vent.trigger "change:grid", grid
    @__gridSize = grid

  App.$html.on "click", "a[data-navigate]", (event) ->
    do event.preventDefault
    App.navigate $(event.currentTarget).attr('href'), {trigger: true}

  App.vent.on "auth:not_valid", ->
    $.removeCookie '_probe_tkn'
    delete App.user
    App.navigate 'login', trigger: true

  App.reqres.setHandler "set:user", (user) ->
    App.user = new App.Entities.User user
    App.vent.trigger "user:login"
    do App.boards.fetch

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
      route: options.route.replace(/^\/|\/$/g, '')

    App.__token = $.cookie '_probe_tkn'

    if options.data
      App.user = new App.Entities.User options.data.user
      App.boards = new App.Entities.Boards options.data.collections
    else
      App.boards = new App.Entities.Boards

  App.on "start", ->
    App.$window.resize()

    route = @options.route or App.rootRoute
    route = 'login' unless App.user

    Backbone.history.start {pushState: true, silent: route isnt @options.route}
    @navigate route, {trigger: true, replace: true}

  App