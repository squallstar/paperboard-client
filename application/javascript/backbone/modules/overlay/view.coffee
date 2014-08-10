# @Collector.module "Overlay", (Overlay, App, Backbone, Marionette, $, _) ->

#   class Overlay.Login extends Marionette.Layout
#     template: "login-overlay"
#     className: "login"

#     events:
#       "click .button" : "doLogin"
#       "click .nope" : "doSkip"

#     doLogin: (event) ->
#       do event.preventDefault
#       window.location.href = '/auth/twitter'
#       @$el.fadeOut 1000

#     doSkip: (event) ->
#       do event.preventDefault
#       @$el.fadeOut 500, =>
#         do @close

#     onBeforeClose: ->
#       App.body.removeClass 'with-overlay'

#     onRender: ->
#       App.body.addClass 'with-overlay'