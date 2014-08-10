# @Collector.module "Articles", (Articles, App, Backbone, Marionette, $, _) ->
#   @startWithParent = false

#   class Articles.Router extends Marionette.AppRouter
#     appRoutes:
#       "articles" : "listArticles"
#       "search/:query": "searchQuery"

#   Articles.Controller =
#     View: ->
#       App.content.show new Articles.View
#         collection: new App.Entities.Articles

#   API =
#     listArticles: ->
#       if App.user
#         $('.titlebar span').html "your twitter timeline &bull; <a href='//twitter.com/#{App.user.get('screen_name')}' target='_blank'>#{App.user.get('screen_name')}</a>"
#       else
#         $('.titlebar span').html 'from the web &bull; collected by <a href="//twitter.com/squallstar" target="_blank">@squallstar</a>'
#         #App.request "show:login"

#       $('#header input').val ''
#       Articles.Controller.View()

#     searchQuery: (query) ->
#       #return App.navigate("articles", {trigger: true, replace: true}) unless App.user

#       App.header.currentView.render()
#       App.request "search", query

#   App.addInitializer ->
#     new Articles.Router
#       controller: API

#   App.reqres.setHandler "search", (query) =>
#     App.content.close()
#     collection = null

#     App.searchQuery = query

#     if query is '' or not query
#       App.request "search:clear"
#       App.navigate "articles", trigger: false, replace: false
#       return API.listArticles()

#     view = new Articles.View
#       collection: new App.Entities.SearchArticles [], query
#     App.content.show view

#     $('.titlebar span').html "#{query}"

#     # Just update the fragment and history
#     q = encodeURIComponent query.replace('/', '')
#     App.navigate "search/#{q}", {trigger: false, replace: false}

#     $('html, body').scrollTop 0

#   App.reqres.setHandler "collection:articles", (collection) ->
#     App.content.close()

#     $('.titlebar span').html "#{collection.get('name')}"

#     view = new Articles.View
#       collection: collection.articles
#     App.content.show view

#   App.reqres.setHandler "focus", (link) ->
#     if Articles.linkOnFocus
#       Articles.linkOnFocus.removeFocus()
#     if link then Articles.linkOnFocus = link else Articles.linkOnFocus = false

