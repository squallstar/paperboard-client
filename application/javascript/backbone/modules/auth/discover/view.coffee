@Paperboard.module "Auth.Discover", (Discover, App, Backbone, Marionette, $, _) ->

  Discover.TagView = Marionette.ItemView.extend
    template: "discover-tag"
    tagName: "li"

  # -------------------------------------------------------------------------

  Discover.View = Marionette.CompositeView.extend
    template: "discover"
    className: "frms"
    childView: Discover.TagView
    childViewContainer: "ul.tags"

    events:
      "click .btn-skip" : "didClickSkip"

    firstRender: true

    ui:
      tags: "ul.tags"

    loadTags: ->
      if @collection.length is 0
        @collection.fetch
          error: =>
            didClickSkip event

    didClickSkip: (event) ->
      if event then do event.preventDefault
      App.user.pot.save 'discover_seen', true
      App.navigate App.rootRoute, true
      App.request "show:intro:walkthrough"

    onDomRefresh: ->
      if @firstRender
        @firstRender = false
        do @loadTags
        App.goTop 150