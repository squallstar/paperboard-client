@Paperboard.module "Helpers", (Helpers, App, Backbone, Marionette, $, _) ->

  class Helpers.RegExps

    @getSafeString: (s) ->
      s.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

    @isValidEmail: (email) ->
      String(email).match(/^\s*[\w\-\+_]+(?:\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(?:\.[\w‌​\-\+_]+)*\s*$/)

    @isValidUrl: (url) ->
      String(url).match /[-a-zA-Z0-9@:%_\+.~#?&\/\/=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/

  # --------------------------------------------------------------------------

  class Helpers.Utils

    @bigNumberLabel: (number) ->
      if number >= 1000000
        Math.ceil(number/1000000) + "M"
      else if number >= 1000
        Math.ceil(number/1000) + "K"
      else
        number

    @getUrlParams: (paramName, forceUrl) ->
      url = forceUrl || window.document.URL.toString()

      if url.indexOf "?" > 0
        arrParams = url.split "?"
        if arrParams.length > 1
          arrUrlParams = arrParams[1].split "&"

          for param in arrUrlParams
            sParam = param.split "="
            if sParam[0] == paramName
              return sParam[1].split("#")[0]
      false

    @stripTags: (str)->
      return str.replace(/(<([^>]+)>)/ig, "")

    @getSnakeCase: (str)->
      return str.split(" ").join("_")

    @capitalize: (str)->
      return str.charAt(0).toUpperCase() + str.slice(1)