@Paperboard.module "Header", (Header, App, Backbone, Marionette, $, _) ->

    Header.Show = ->
      @layout = new Header.View
      App.header.show @layout

    App.reqres.setHandler "change:nav", (object = {}) ->
      App.execute "ensure:header"
      Header.layout.setNav object

    App.vent.on "user:login", ->
      App.execute "ensure:header"

    App.commands.setHandler "ensure:header", ->
      unless App.header.hasView() then do Header.Show

    App.commands.setHandler "hide:header", ->
      if App.header.hasView() then App.header.empty()