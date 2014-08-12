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

    ui:
      toggleSidebar: ".nav .toggle-sidebar"

    templateHelpers: ->
      "user": if App.user then App.user.toJSON() else false

    revealSidebar: (event) ->
      do event.preventDefault
      return if App.$html.hasClass 'with-sidebar'

      App.request "create:sidebar"
      App.$html.addClass 'with-sidebar'

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