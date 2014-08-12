@Paperboard.module "Header", (Header, App, Backbone, Marionette, $, _) ->

    Header.Show = ->
      @layout = new Header.View
      App.header.show @layout

    App.reqres.setHandler "change:nav", (object) ->
      unless Header.layout then do Header.Show
      Header.layout.setNav object

    App.vent.on "user:login", ->
      if Header.layout
        Header.layout.render()
      else
        do Header.Show