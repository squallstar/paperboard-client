@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.Tag = Backbone.Model.extend
    idAttribute: 'name'

  # -------------------------------------------------------------------------

  Entities.Tags = Backbone.AuthCollection.extend
    model: Entities.Tag

    url: 'v3/directory/tags'

    parse: (data) ->
      tags = []
      for el in data
        tags.push {name: el}
      tags