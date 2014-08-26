@Paperboard.module "Walkthrough", (Walkthrough, App, Backbone, Marionette, $, _) ->

  Walkthrough.View = Marionette.ItemView.extend
    id: "walkthrough"
    template: "walkthrough"

    ui:
      cover: ".step-cover"
      content: ".step-content"

    events:
      "click .prev" : "showPrevStep"
      "click .next, .step-cover" : "showNextStep"
      "click .dismiss" : "dismissView"

    idx: 0

    initialize: (options) ->
      @options = options.config
      @$el.fadeOut 0

    dismissView: (event) ->
      if event then do event.preventDefault

      step = @options.steps[@idx]
      if step.onAfter then step.onAfter.call(@, $(step.el), step)

      @$el.fadeOut 500, =>
        do @destroy
        if @options.onClose then @options.onClose(@)

    showNextStep: (event) ->
      if event then do event.preventDefault

      if @options.steps.length is @idx+1
        return do @dismissView

      if @options.steps[@idx].elClick isnt true and $(event.currentTarget).hasClass 'step-cover'
        return

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

      template = if step.template then step.template else "walkthrough-step"

      $content = Backbone.Marionette.Renderer.render template, step

      $el = $(step.el)

      if step.el and not $el.length
        return @showStep index+1

      @ui.content.animate({left: '+=5', opacity: 0}, 250).fadeOut 0

      cb = =>
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
          @ui.content.css 'opacity', 1
          @ui.content.html $content
          @ui.content.attr 'data-position', step.position
          if step.position is 'right'
            @ui.content.css
              top: top - 11
              left: left + width + 25
              marginLeft: 0
              marginTop: 0
          else if step.position is 'bottom-right'
            @ui.content.css
              top: top - @ui.content.height() + 23
              left: left + width + 25
          else if step.position is 'left'
            @ui.content.css
              top: top - 10
              left: left - @ui.content.width() - 55

        @ui.cover.css {
          top: top
          left: left
          width: width
          height: height
        }

        @ui.cover.toggleClass('click-through', step.elClick is true)

        @ui.cover.fadeIn 250, =>
          window.setTimeout =>
            @ui.cover.addClass 'visible'
            window.setTimeout =>
              @ui.content.fadeIn 500
            , 500
          , 500

      unless step.el
        cb = =>
          @ui.content.fadeOut 250, =>
            @ui.content.css 'opacity', 1
            @ui.content.html $content
            @ui.content.removeAttr 'data-position'

            @ui.content.css
              top: '50%'
              left: '50%'
              marginTop: -@ui.content.height()/2
              marginLeft: -@ui.content.width()/2

            @ui.cover.css {
              top: 0
              left: 0
              width: 0
              height: 0
            }

            @ui.cover.fadeIn 250, =>
              if step.animate is 'slide-top'
                @ui.content.css
                  opacity: 0
                  top: '100%'
                @ui.content.fadeIn(0).animate {top: '50%', opacity: 1}, 500
              else
                @ui.content.fadeIn 500

      if step.onBefore then step.onBefore.call(@, $el, step, cb)
      else do cb

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

    App.$htmlbody.animate
      scrollTop: 0
    , 200, =>
      App.$body.append w.$el
      do w.render

  App.reqres.setHandler "show:intro:walkthrough", ->
    App.$wrapper.css 'opacity', 0

    window.setTimeout =>
      sampleBoard = App.request "find:board", "p212353f5b532ade33"

      App.request "walkthrough", {
        steps: [
          {
            template: "walkthrough-intro"
            animate: "slide-top"
            onBefore: ($el, step, callback) ->
              do callback
              window.setTimeout =>
                App.$wrapper.animate {opacity: 1}, 2000
              , 1000
          },
          {
            el: "#nav .toggle-sidebar"
            elClick: true
            title: "This is where the magic happens"
            content: "The main navigation toggle &dash; simply hover here to reveal your boards and navigate through them."
            position: 'right'
            onBefore: ($el, step, callback) ->
              App.$htmlbody.stop(true).animate
                scrollTop: 0
              , 500, ->
                do callback
          }
          {
            el: "#rg-sidebar"
            onBefore: ($el, step, callback) ->
              App.request "create:sidebar"
              App.$html.addClass 'with-sidebar'
              do callback
            onAfter: ->
              App.execute "hide:sidebar"
            title: "Your boards"
            content: "View and manage your boards, reorder them and create as many new as you like."
            position: 'right'
          }
          {
            el: "#main-content article:eq(1)"
            title: "Articles"
            content: "Articles are the main pillars of your boards. Click on its preview to reveal more details."
            position: "right"
            coverPadding: 11
            onBefore: ($el, step, callback) ->
              App.$htmlbody.animate
                scrollTop: $el.offset().top - 300
              , 500, ->
                do callback
          }
          {
            el: "#main-content article .box.author"
            elClick: true
            title: "View more about the author"
            content: "Each article displays information about the owner on the bottom. Click it to search for more content by the same author!"
            position: "bottom-right"
            onBefore: ($el, step, callback) ->
              App.$htmlbody.animate
                scrollTop: $el.position().top - 300
              , 500, ->
                window.setTimeout ->
                  do callback
                , 100
          }
          {
            el: "header .toggle-follow"
            elClick: true
            title: "Follow boards you like"
            content: "Following boards you like is dead simple. Just press that red button to instantly save them to your Paperboard!"
            position: "left"
            onBefore: ($el, step, callback) ->
              App.$htmlbody.animate
                scrollTop: 0
              , 500, ->
                App.request "load:board", sampleBoard
                do callback
            onAfter: ->
              App.navigate App.rootRoute, true
          }
        ]
      }
    , 500