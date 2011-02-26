request = require 'request'
querystring = require 'querystring'

# @see http://developers.facebook.com/docs/authentication/#app-login
get_app_access_token = ( app_id, app_secret, cb ) ->
  params = 
    client_id: app_id
    client_secret: app_secret
    grant_type: 'client_credentials'
  url = 'https://graph.facebook.com/oauth/access_token?' + querystring.stringify params
  request.get uri:url, (error, response, body) ->
    if error?
      cb error
    else if response.statusCode is 200
      cb null, body.split('=')[1]
    else
      # can we parse body? ( facebook encodes errors as JSON )
      if (b = JSON.parse body)?
        cb b, null
      cb response, null # TODO: improve error handling

make_raw_api_call = (access_token, method, path, params, cb, eb) ->
  console.log 'raw_api_call'
  console.log [access_token, method, path, params, cb, eb]
  p = {}
  ( p[k] = v ) for own k, v of params
  p.access_token = access_token
  if path.indexOf('/') isnt 0
    path = '/' + path
  opts = 
    uri: 'https://graph.facebook.com' + path + '?' + querystring.stringify p
    method: method
  request opts, (error, response, body) ->
    if error?
      # TODO: handle errors elegantly
      console.log 'HTTP ERROR'
      console.log error
      eb error
    else
      cb JSON.parse body

positional_call = (access_token, args) ->
  method = 'get'
  path = null
  params = {}
  cb = null
  switch ( typeof a for a in args ).join ','
    when 'string,function' then [path, cb] = args
    when 'string,string,function' then [path, method, cb] = args
    when 'string,object,function' then [path, params, cb] = args
    when 'string,string,object,function' then [path, method, params, cb] = args
  make_raw_api_call access_token, method, path, params, cb

# returns a function that will queue all calls
# until the token is set by calling api.set_access_token
get_api = ->
  queue = []
  token = null
  func = ->
    if token?
      positional_call token, arguments
    else
      queue.push arguments
  func.set_access_token = (t, err) ->
    token = t
    func.token = t
    ( positional_call token, queued ) for queued in queue
    queue = null
  func

# should behave just like the client side SDK
# http://developers.facebook.com/docs/reference/javascript/fb.api/

exports.get_app_access_token = get_app_access_token
exports.make_raw_api_call = make_raw_api_call
exports.get_api = get_api
exports.get_api_for_app = (app_id, app_secret) ->
  api = get_api()
  get_app_access_token app_id, app_secret, (err, res) ->
    api.set_access_token res # TODO: what about the error condition?
  api
