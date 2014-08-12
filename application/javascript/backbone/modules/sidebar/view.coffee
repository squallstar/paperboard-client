@Paperboard.module "Sidebar", (Sidebar, App, Backbone, Marionette, $, _) ->

  Sidebar.Item = Marionette.ItemView.extend
    template: "sidebar-item"
    tagName: "li"

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
      return if @hideSidebarTimeout

      @hideSidebarTimeout = window.setTimeout =>
        App.$html.removeClass 'with-sidebar'
      , 650

    clearSidebarTimeout: ->
      if @hideSidebarTimeout
        clearTimeout @hideSidebarTimeout
        delete @hideSidebarTimeout

    onBeforeClose: ->
      do @clearSidebarTimeout