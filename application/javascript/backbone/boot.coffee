@Paperboard = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = "everything"

  App.$window = $ window
  App.$html = $ 'html'
  App.fixedHeader = false

  App.addRegions
    header:  "#rg-header"
    sidebar: "#rg-sidebar"
    content: "#rg-content"

  App.$anim = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend'

  App.goTop = (speed = 0, callback) ->
    $('html, body').animate
      scrollTop: 0
    , speed, callback

  App.scrollTo = ($element, speed = 150, callback) ->
    $element
    if $element.length
      $element = $element.offset().top

    $('html, body').animate
      scrollTop: $element
    , speed, callback

  App.$window.resize ->
    App.$window._height = App.$window.height()

    width = 0
    $content = $ '#main-content'
    if $content.length > 0
      width = $content.width()
    else
      width = App.$window.width()

    grid = Math.round width/290
    if grid > 6 or grid < 1 then grid = 1
    return if not grid or @__gridSize is grid
    App.$html.removeClass("grid-#{@__gridSize}").addClass "grid-#{grid}"
    App.vent.trigger "change:grid", grid
    @__gridSize = grid

  App.$window.scroll ->
    scrollTop = App.$window.scrollTop()
    if scrollTop <= 60 and App.fixedHeader
      App.$html.removeClass 'fixed-header'
      App.fixedHeader = false
    else if scrollTop > 60 and not App.fixedHeader
      App.$html.addClass 'fixed-header'
      App.fixedHeader = true

  App.$html.on "click", "a[data-navigate]", (event) ->
    do event.preventDefault
    App.navigate $(event.currentTarget).attr('href'), {trigger: true}
    App.execute "hide:sidebar"

  App.vent.on "auth:not_valid", ->
    $.removeCookie '_probe_tkn'
    delete App.user
    App.navigate 'login', trigger: true

  App.reqres.setHandler "set:user", (user) ->
    App.user = new App.Entities.User user
    App.vent.trigger "user:login"
    do App.boards.fetch

  App.reqres.setHandler 'set:intent', (intent) ->
    App.__intent = intent

  App.reqres.setHandler 'intent', ->
    App.__intent

  App.setToken = (token) ->
    $.cookie '_probe_tkn', token
    App.__token = token

  App.getToken = ->
    App.__token

  App.url = (endpoint) ->
    App.options.url + endpoint


  # -------------------------------------------------------------------------------------
  # Full screen stuff

  App.supportsFullscreen = document.fullscreenEnabled or document.webkitFullscreenEnabled

  App.isFullscreen = ->
    if App.supportsFullscreen
      return document.fullscreenElement or document.webkitFullscreenElement
    false

  App.switchFullScreen = ->
    if App.supportsFullscreen
      if App.isFullscreen() then App.exitFullscreen() else App.enterFullscreen()

  App.exitFullscreen = ->
    if App.supportsFullscreen
      if document.exitFullscreen then do document.exitFullscreen
      else if document.webkitExitFullscreen then do document.webkitExitFullscreen

  App.replaceOriginalPushState = ->
    if not App.isFullscreen() then Backbone.history._hasPushState = App.hasPushState

  document.documentElement.onwebkitfullscreenchange = App.replaceOriginalPushState
  document.documentElement.mozfullscreenchange = App.replaceOriginalPushState

  App.enterFullscreen = (element = undefined) ->
    return unless App.supportsFullscreen
    Backbone.history._hasPushState = false

    element ||= document.documentElement
    if element.requestFullscreen
      element.requestFullscreen()
    else if element.webkitRequestFullscreen
      element.webkitRequestFullscreen Element.ALLOW_KEYBOARD_INPUT

  # -------------------------------------------------------------------------------------

  App.on "before:start", (options) ->
    App.$body = $('body')

    @options =
      url: options.entrypoint.replace(/^\/|\/$/g, '')
      route: options.route.replace(/^\/|\/$/g, '')

      open_routes: [
        /board\/([A-z0-9]+)/,
        /article/,
        /signup/,
      ]

    App.__token = $.cookie '_probe_tkn'

    if options.data
      App.user = new App.Entities.User options.data.user
      App.boards = new App.Entities.Boards options.data.collections
    else
      App.boards = new App.Entities.Boards

  App.on "start", ->
    App.$htmlbody = $ 'html, body'
    App.$wrapper = $ '#wrapper'
    App.$window.resize()

    route = @options.route or App.rootRoute

    unless App.user
      valid = false
      for r in App.options.open_routes
        if r.test(route)
          valid = true
          break
      route = 'login' unless valid

    if App.user and route isnt 'logout'
      if App.user.needsToConnectServices()
        route = 'connect-services'
      else if App.user.needsToDiscoverContent()
        route = 'discover'
      else if App.user.needsWalkthrough()
        route = App.rootRoute
        App.request "show:intro:walkthrough"

    Backbone.history.start {pushState: true, silent: route isnt @options.route}
    @navigate route, {trigger: true, replace: true}

  App