@Paperboard.module "Overlay", (Overlay, App, Backbone, Marionette, $, _) ->

  fn = (event) ->
    do event.preventDefault
    do event.stopPropagation

  is_closing_animated = false

  Overlay.Region = Marionette.Region.extend
    el: '#rg-overlay'

    onShow: ->
      is_closing_animated = false
      window.setTimeout =>
        App.$html.addClass 'with-overlay'
      , 50

    onBeforeEmpty: ->
      App.$html.removeClass 'with-overlay'

  App.addRegions
    overlay: Overlay.Region

  App.reqres.setHandler 'overlay:dismiss:animated', ->
    if App.overlay.hasView()
      is_closing_animated = true
      App.$html.removeClass 'with-overlay'
      window.setTimeout ->
        if is_closing_animated
          App.overlay.empty()
      , 1000