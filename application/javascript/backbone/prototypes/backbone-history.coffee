do (Backbone) ->
  Backbone.history.stack = []
  originalHistory = Backbone.history.navigate

  Backbone.history.navigate = (fragment) ->
    Backbone.history.stack.push fragment
    originalHistory.apply @, arguments

  Backbone.history.canGoBack = ->
    Backbone.history.stack.length > 1

  Backbone.history.previousFragment = ->
    len = Backbone.history.stack.length
    i = 0
    if len > 1 then i=len-2
    Backbone.history.stack[i]