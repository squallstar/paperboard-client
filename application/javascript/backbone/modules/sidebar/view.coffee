@Paperboard.module "Sidebar", (Sidebar, App, Backbone, Marionette, $, _) ->

  Sidebar.Item = Marionette.ItemView.extend
    template: "sidebar-item"
    tagName: "li"

    events:
      "click a" : "didClickItem"

    attributes: ->
      'data-pid': @model.get('private_id')

    didClickItem: (event) ->
      do event.preventDefault
      @$el.closest('ul').find('li').removeClass 'current'
      @$el.addClass 'current'
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