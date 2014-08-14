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

  Header.UserInfo = Marionette.ItemView.extend
    template: "header-user-info"

  # --------------------------------------------------------------------------

  Header.View = Marionette.ItemView.extend
    template: "header"
    tagName: "header"

    events:
      "mouseenter #nav .toggle-sidebar" : "revealSidebar"
      "click #nav .toggle-sidebar"      : "revealSidebar"
      "click #nav .toggle-settings"     : "toggleSettings"
      "click #nav .toggle-follow"       : "toggleFollow"
      "click #nav .logo"                : "backToTop"

    ui:
      nav: "#nav"
      toggleSidebar: "#nav .toggle-sidebar"
      toggleFollow: "#nav .toggle-follow"

    initialize: ->
      @userInfo = new Header.UserInfo

    templateHelpers: ->
      "user": if App.user then App.user.toJSON() else false

    revealSidebar: (event) ->
      do event.preventDefault
      return if App.$html.hasClass 'with-sidebar'

      App.request "create:sidebar"
      App.$html.addClass 'with-sidebar'

    toggleSettings: (event) ->
      do event.preventDefault
      do event.stopPropagation

    toggleFollow: (event) ->
      do event.preventDefault
      do event.stopPropagation

      # TODO: if not logged in, sign up

      if @subject.isFollowed()
        @subject.destroy()
        #App.boards.remove @subject
        @updateFollowToggle false
      else
        @updateFollowToggle true
        @subject.follow =>
          App.boards.add @subject

    updateFollowToggle: (followed) ->
      if followed
        @ui.nav.addClass 'type-followed'
        @ui.toggleFollow.addClass('pressed').text 'Following'
      else
        @ui.toggleFollow.removeClass('pressed').text 'Follow board'
        @ui.nav.removeClass 'type-followed'

    setNav: (object) ->
      @subject = object
      if object._class is 'Board'
        @ui.toggleSidebar.text object.get('name')
        @ui.nav.toggleClass 'type-twitter', object.isTwitterType()
        @ui.nav.toggleClass 'type-owned', object.isOwned()
        @ui.nav.toggleClass 'type-can-be-followed', object.canBeFollowed()

        if object.hasContexts()
          @ui.nav.removeClass 'type-with-user'
        else
          console.log @userInfo
          @userInfo.model = object
          @userInfo.render()
          @ui.nav.addClass 'type-with-user'

        @updateFollowToggle object.isFollowed()
      else
        @ui.nav.removeClass()

    backToTop: (event) ->
      do event.preventDefault
      do event.stopPropagation
      $("html, body").animate {scrollTop:0}, 380, 'swing'

    onBeforeClose: ->
      @userInfo.close()

    onClose: ->
      App.$html.removeClass 'with-sidebar'
      do App.sidebar.empty

    onRender: ->
      @$el.find('.user-info').append @userInfo.$el


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