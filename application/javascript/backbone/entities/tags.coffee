@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.Tag = Backbone.Model.extend
    idAttribute: 'name'

    defaults:
      selected: false
      suggested: false

  # -------------------------------------------------------------------------

  Entities.Tags = Backbone.AuthCollection.extend
    model: Entities.Tag

    url: ->
      url = 'v3/directory/tags'
      if @length > 0
        url += '?filter=' + encodeURIComponent(@selectedTags().join(','))
      url

    selectedTags: ->
      tags = []
      for tag in @models
        if tag.get('selected') then tags.push tag.get('name')
      tags

    firstNotSelected: ->
      for tag in @models
        if tag.get('selected') is false then return tag
      undefined

    fetchMore: (callback) ->
      @fetch
        update: true
        add: true
        remove: false
        success: ->
          console.log arguments
          if callback then callback arguments