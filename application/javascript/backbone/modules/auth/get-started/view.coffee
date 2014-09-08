@Paperboard.module "Auth.GetStarted", (GetStarted, App, Backbone, Marionette, $, _) ->

  GetStarted.View = Marionette.ItemView.extend
    template: "get-started"
    className: "frms"

    events:
      "click .btn-continue" : "didClickContinue"

    ui:
      content: '.content'

    templateHelpers: ->
      firstName: App.user.getFirstName()

    didClickContinue: (event) ->
      do event.preventDefault
      App.navigate 'connect-services', true

    onRender: ->
      @ui.content.css 'opacity', 0

    onDomRefresh: ->
      App.goTop 1
      @$el.find('.get-started-logo').addClass('bounceIn animated').one App.$anim, =>
        @ui.content.delay(300).animate {opacity: 1}, 300