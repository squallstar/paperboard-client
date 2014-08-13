@Paperboard.module "Header", (Header, App, Backbone, Marionette, $, _) ->

#   class Header.Suggestion extends Marionette.ItemView
#     tagName: "div"
#     className: "suggestion"
#     template: "suggestion"

#     events:
#       "click" : "clickSuggestion"

#     clickSuggestion: (event) ->
#       do event.preventDefault
#       query = @model.get 'domain'
#       @model.collection.reset()

#       App.request "search:domain", query


#   # --------------------------------------------------------------------------

#   class Header.Suggestions extends Marionette.CollectionView
#     className: "suggestions"
#     itemView: Header.Suggestion

#     collectionEvents:
#       "reset": ->
#         @$el.removeClass 'open'

#         if @req and @req.readyState > 0 and @req.readyState < 4
#           @req.abort()

#     fetch: (query) ->
#       if query is ''
#         return @collection.reset()

#       @collection.query = query

#       @req = @collection.fetch
#         success: =>
#           if @collection.length > 0
#             @$el.addClass 'open'
#           else
#             @$el.removeClass 'open'

  # --------------------------------------------------------------------------

  Header.View = Marionette.ItemView.extend
    template: "header"
    tagName: "header"

    events:
      "mouseenter .nav .toggle-sidebar" : "revealSidebar"
      "click .nav .toggle-sidebar"      : "revealSidebar"
      "click .nav .logo"                : "backToTop"

    ui:
      nav: ".nav"
      toggleSidebar: ".nav .toggle-sidebar"
      toggleSettings: ".nav .toggle-settings"

    templateHelpers: ->
      "user": if App.user then App.user.toJSON() else false

    revealSidebar: (event) ->
      do event.preventDefault
      return if App.$html.hasClass 'with-sidebar'

      App.request "create:sidebar"
      App.$html.addClass 'with-sidebar'

    onRenderTemplate: ->
      @ui.toggleSettings.addClass 'hide'

    setNav: (object) ->
      is_board = object._class is 'Board'
      can_edit = is_board and App.user and object.get('owned_collection')

      @ui.nav.removeClass 'type-twitter'
      @ui.toggleSettings.toggleClass 'hide', not can_edit

      if is_board
        @ui.toggleSidebar.text object.get('name')
        if object.get('name').indexOf('@') is 0
          @ui.nav.addClass 'type-twitter'

    backToTop: (event) ->
      do event.preventDefault
      do event.stopPropagation
      $("html, body").animate {scrollTop:0}, 380, 'swing'

    onClose: ->
      App.$html.removeClass 'with-sidebar'
      do App.sidebar.empty


    # doSearch: (e) ->
    #   return unless @ui.search.hasClass 'open'
    #   if @suggestionsInterval then clearInterval @suggestionsInterval

    #   if e.which is 13
    #     query = @ui.searchinput.val()
    #     if query
    #       @ui.searchinput.blur()
    #       @suggestions.collection.reset()
    #       App.request "search", query
    #     else
    #       @closeSearchBox()
    #   else if e.which is 27
    #     @ui.searchinput.val ''
    #     @closeSearchBox()
    #   else
    #     @suggestionsInterval = setTimeout (=>
    #       @suggestions.fetch @ui.searchinput.val()
    #     ), 300