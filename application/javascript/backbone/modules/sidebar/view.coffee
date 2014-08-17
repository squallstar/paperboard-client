@Paperboard.module "Sidebar", (Sidebar, App, Backbone, Marionette, $, _) ->

  Sidebar.Item = Marionette.ItemView.extend
    template: "sidebar-item"
    tagName: "li"

    events:
      "click a" : "didClickItem"

    ui:
      item: ".item"

    attributes: ->
      'data-pid': @model.get('private_id')

    didClickItem: (event) ->
      do event.preventDefault
      @$el.closest('ul').find('li').removeClass 'current'
      @$el.addClass 'current'

    onRender: ->
      if @model.isFollowed()
        @ui.item.addClass 'icon-person'
        @ui.item.append "<img src='#{@model.get('user').image_url}' />"
      else if @model.isTwitterType()
        @ui.item.addClass 'icon-twitter'
      else
        @ui.item.addClass 'icon-owned'

  # --------------------------------------------------------------------------

  Sidebar.View = Marionette.CompositeView.extend
    template: "sidebar"
    tagName: "section"
    childView: Sidebar.Item
    childViewContainer: "ul.boards"

    events:
      "mouseenter" : "clearSidebarTimeout"
      "mouseleave" : "scheduleHideSidebar"

    initialize: ->
      @$el.bind "mousewheel DOMMouseScroll", (e) ->
        e0 = e.originalEvent
        delta = e0.wheelDelta or -e0.detail
        @scrollTop += ((if delta < 0 then 1 else -1)) * 15
        e.preventDefault()

    scheduleHideSidebar: (event) ->
      do event.preventDefault
      return if @hideSidebarTimeout or not App.$html.hasClass('with-sidebar')

      @hideSidebarTimeout = window.setTimeout =>
        do @hideSidebar
      , 250

    hideSidebar: ->
      App.$html.removeClass 'with-sidebar'
      do @clearSidebarTimeout

    clearSidebarTimeout: ->
      if @hideSidebarTimeout
        clearTimeout @hideSidebarTimeout
        delete @hideSidebarTimeout

    setSortable: ->
      @sortableElement = @$el.sortable
        items: "#{@childViewContainer} li"
        containment: "parent"
        handle: ".move-handle"

        update: =>
          i = 0
          for item in @$el.find("#{@childViewContainer} li")
            pid = $(item).data 'pid'
            for board in @collection.models
              if board.get('private_id') is pid
                board.set {'position': i}, {silent: true}
                i++

          @collection.reorder()

    onBeforeClose: ->
      do @clearSidebarTimeout

      if @sortableElement? and @$el.is ".ui-sortable"
        @$el.sortable "disable"

    onRender: ->
      do @setSortable