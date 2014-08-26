@Paperboard.module "Walkthrough", (Walkthrough, App, Backbone, Marionette, $, _) ->

  Walkthrough.View = Marionette.ItemView.extend
    id: "walkthrough"
    template: "walkthrough"

    ui:
      cover: ".step-cover"
      content: ".step-content"

    events:
      "click .prev" : "showPrevStep"
      "click .next" : "showNextStep"
      "click .dismiss" : "dismissView"

    idx: 0

    initialize: (options) ->
      @options = options.config
      @$el.fadeOut 0

    dismissView: ->
      step = @options.steps[@idx]
      if step.onAfter then step.onAfter.call(@, $(step.el), step)

      @$el.fadeOut 500, =>
        do @destroy
        if @options.onClose then @options.onClose(@)

    showNextStep: (event) ->
      do event.preventDefault

      @ui.cover.removeClass 'visible'

      step = @options.steps[@idx]
      if step.onAfter then step.onAfter.call(@, $(step.el), step)

      @showStep @idx+1

    showPrevStep: (event) ->
      do event.preventDefault

      step = @options.steps[@idx]
      if step.onAfter then step.onAfter.call(@, $(step.el), step)

      @showStep @idx-1

    showStep: (index) ->
      step = @options.steps[index]

      step.back = index > 0
      step.next = index+1 < @options.steps.length
      step.dismiss = index+1 is @options.steps.length

      $content = Backbone.Marionette.Renderer.render "walkthrough-step", step

      $el = $ step.el
      if step.onBefore then step.onBefore.call(@, $el, step)

      @idx = index

      top = $el.offset().top
      left = $el.offset().left
      width = $el.outerWidth()
      height = $el.outerHeight()

      if step.coverPadding
        top += step.coverPadding
        left += step.coverPadding
        width -= step.coverPadding*2
        height -= step.coverPadding*2

      @ui.content.fadeOut 250, =>
        @ui.content.html $content
        @ui.content.attr 'data-position', step.position
        if step.position is 'right'
          @ui.content.css
            top: top - 12
            left: left + width + 30
        else if step.position is 'bottom-right'
          @ui.content.css
            top: top - @ui.content.height() + 23
            left: left + width + 30

      @ui.cover.css {
        top: top
        left: left
        width: width
        height: height
      }

      @ui.cover.fadeIn 250, =>
        window.setTimeout =>
          @ui.cover.addClass 'visible'
          window.setTimeout =>
            @ui.content.fadeIn 500
          , 500
        , 500

    onDestroy: ->
      App.$body.css 'overflow', 'auto'

    onRender: ->
      @ui.content.fadeOut 0
      @ui.cover.fadeOut 0
      @$el.fadeIn 200

      App.$body.css 'overflow', 'hidden'
      @showStep 0

  App.reqres.setHandler "walkthrough", (config) ->
    w = new Walkthrough.View
      config: config

    App.$body.append w.$el
    do w.render

  window.setTimeout =>

    App.request "walkthrough", {
      onClose: ->
        console.log 'dismissed'
      steps: [
        {
          el: "#nav .toggle-sidebar"
          title: "Welcome to Paperboard"
          content: "Just a few hints to get you started. This toggle will reveal all your boards."
          position: 'right'
        },
        {
          el: "#rg-sidebar"
          onBefore: ->
            App.request "create:sidebar"
            App.$html.addClass 'with-sidebar'
          onAfter: ->
            App.execute "hide:sidebar"
          title: "Your boards"
          content: "Here's the boards sidebar. View and manage your boards, reorder them and create as many new as you like."
          position: 'right'
        },
        {
          el: "#main-content article:eq(1)"
          title: "Articles"
          content: "They are the main pillars of your boards. Click on it to read more about it. Try it now!"
          position: "right"
          coverPadding: 11
        },
        {
          el: "#main-content article .box.author"
          title: "View more about the author"
          content: "Each article displays information about the owner on the bottom. Click it to search for more content by the same author!"
          position: "bottom-right"
        }
      ]
    }
  , 1000