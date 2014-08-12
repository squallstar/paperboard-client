@Paperboard.module "Sidebar", (Sidebar, App, Backbone, Marionette, $, _) ->

  Sidebar.Item = Marionette.ItemView.extend
    template: "sidebar-item"
    tagName: "li"

    events:
      "click a" : "didClickItem"

    didClickItem: (event) ->
      do event.preventDefault
      @$el.closest('ul').find('a').removeClass 'current'
      @$el.find('a').addClass 'current'
      App.$html.removeClass 'with-sidebar'

    onRender: ->
      if @model.get('name').indexOf('@') is 0
        @$el.find('a').addClass 'icon-twitter'
      else
        @$el.find('a').addClass 'icon-folder'

  # --------------------------------------------------------------------------

  Sidebar.View = Marionette.CompositeView.extend
    template: "sidebar"
    tagName: "section"
    childView: Sidebar.Item
    childViewContainer: "ul.boards"

    events:
      "mouseenter" : "clearSidebarTimeout"
      "mouseleave" : "scheduleHideSidebar"

    scheduleHideSidebar: (event) ->
      do event.preventDefault
      return if @hideSidebarTimeout or not App.$html.hasClass('with-sidebar')

      @hideSidebarTimeout = window.setTimeout =>
        App.$html.removeClass 'with-sidebar'
      , 250

    clearSidebarTimeout: ->
      if @hideSidebarTimeout
        clearTimeout @hideSidebarTimeout
        delete @hideSidebarTimeout

    onBeforeClose: ->
      do @clearSidebarTimeout