@Paperboard.module "Header", (Header, App, Backbone, Marionette, $, _) ->

    Header.Show = ->
      @layout = new Header.View
      App.header.show @layout

    App.vent.on "user:login", ->
      if Header.layout
        Header.layout.render()
      else
        do Header.Show