@Paperboard.module "Auth.Discover", (Discover, App, Backbone, Marionette, $, _) ->

  Discover.TagView = Marionette.ItemView.extend
    template: "discover-tag"
    tagName: "li"

    events:
      "click a" : "toggleSelected"

    toggleSelected: (event) ->
      do event.preventDefault
      selected = not @model.get 'selected'
      @model.set 'selected', selected
      @$el.removeClass 'new'
      @$el.toggleClass 'selected bounceIn animated', selected

      @model.set 'suggested', false

      do @onRender

    onRender: ->
      @$el.toggleClass 'selected', @model.get('selected')
      @$el.toggleClass 'new suggested', @model.get('suggested')

    # destroy: ->
    #   return if @isDestroyed
    #   _args = arguments
    #   @$el.hide 350, =>
    #     Marionette.View.prototype.destroy.apply @, _args

  # -------------------------------------------------------------------------

  Discover.View = Marionette.CompositeView.extend
    template: "discover"
    className: "frms"
    childView: Discover.TagView
    childViewContainer: "ul.tags.all"

    events:
      "click .btn-skip" : "didClickSkip"

    firstRender: true

    ui:
      tags: ".primary ul.tags"
      suggestedTags: ".suggested ul.tags"
      otherTags: ".others ul.tags"

    collectionEvents:
      "change:selected" : "didSelectItem"

    loadMore: false

    loadTags: ->
      if @collection.length is 0
        @collection.fetch
          error: =>
            @didClickSkip event

    didClickSkip: (event) ->
      if event then do event.preventDefault
      App.user.pot.save 'discover_seen', true
      App.navigate App.rootRoute, true
      App.request "show:intro:walkthrough"

    didSelectItem: (model) ->
      return if @collection.selectedTags().length < 4

      @$el.find('.proceed').removeClass 'hide'

      @$el.find('li.new').removeClass 'new'

      @loadMore = true
      @collection.fetchMore()

    # onAddChild: (childView) ->
      # if @loadMore
        # unusedItem = @collection.firstNotSelected()
        # if unusedItem
        #   unusedItem.destroy()

    onCollectionRendered: ->
      App.$window.resize()

    attachHtml: (collectionView, childView, index) ->
      if @loadMore
        if childView.model.get('suggested')
          @ui.suggestedTags.append childView.$el
          if @ui.suggestedTags.parent().hasClass 'hide'
            @ui.suggestedTags.parent().removeClass 'hide'
            window.setTimeout =>
              App.scrollTo @ui.suggestedTags, 500
            , 200
        else
          @ui.otherTags.parent().removeClass 'hide'
          @ui.otherTags.append childView.$el
      else
        @ui.tags.append childView.$el

    onDomRefresh: ->
      if @firstRender
        @firstRender = false
        do @loadTags
        App.goTop 150