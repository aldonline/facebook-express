crypto = require 'crypto'
querystring = require 'querystring'

md5 = (data) -> crypto.createHash('md5').update(data).digest 'hex'

# we use this instead of relying on connect middleware 
# to minimize dependencies and upstream interactions
get_cookies_from_request = (req) ->
  cookies = {}
  header = req.headers.cookie
  return cookies unless header
  pairs = header.split /[;,] */
  for pair in pairs
    eq_idx = pair.indexOf '='
    key = pair.substr(0, eq_idx).trim().toLowerCase()
    val = pair.substr(++eq_idx, pair.length).trim()
    if val[0] is '"'
      val = val.slice(1, -1)
      cookies[key] ?= querystring.unescape val, true
  cookies

# will try to extract the facebook cookie from the given request
get_facebook_cookie_from_request = ( req, app_id, app_secret ) ->
  cookies = get_facebook_cookie_from_request req
  if ( c = cookies?["fbs_#{app_id}"] )?
    args =  querystring.parse c
    keys = (k for k of args)
    keys.sort()
    payload = ( "#{k}=#{args[k]}" for k in keys when k isnt 'sig' ).join ''
    return args if args.sig is md5 payload + app_secret
  null

middleware = ( app_id, app_secret ) ->
  ( req, res, next ) ->
    if ( c = req?.cookies?["fbs_#{app_id}"] )?
      args =  querystring.parse c
      keys = (k for k of args)
      keys.sort()
      payload = ( "#{k}=#{args[k]}" for k in keys when k isnt 'sig' ).join ''
      req.fb_cookie = args if args.sig is md5 payload + app_secret
    next()

exports.middleware = middleware
exports.get_cookies_from_request = get_cookies_from_request
exports.get_facebook_cookie_from_request = get_facebook_cookie_from_request