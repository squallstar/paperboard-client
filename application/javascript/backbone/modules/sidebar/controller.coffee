@Paperboard.module "Sidebar", (Sidebar, App, Backbone, Marionette, $, _) ->

  Sidebar.Create = ->
    App.sidebar.show new Sidebar.View
      collection: App.boards

  App.reqres.setHandler "create:sidebar", ->
    unless App.sidebar.hasView() then do Sidebar.Create