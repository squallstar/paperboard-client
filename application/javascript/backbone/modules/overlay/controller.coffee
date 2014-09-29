@Paperboard.module "Overlay", (Overlay, App, Backbone, Marionette, $, _) ->

  fn = (event) ->
    do event.preventDefault
    do event.stopPropagation

  Overlay.Region = Marionette.Region.extend
    el: '#rg-overlay'

    onShow: ->
      App.$html.addClass 'with-overlay'
      App.$html.on 'scroll touchmove mousewheel', fn

    onBeforeEmpty: ->
      App.$html.removeClass 'with-overlay'
      App.$html.off 'scroll touchmove mousewheel', fn

  App.addRegions
    overlay: Overlay.Region
