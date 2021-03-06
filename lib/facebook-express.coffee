http = require 'http'
URL = require 'url'
request = require 'request'
querystring = require 'querystring'

cookie = require './cookie'
client = require './client'
api = require './api'
util = require './util'

class Helper
  constructor: ( opts ) ->
    # base options
    @opts =
      script: '/__fbx.js'
      locale: 'en_US'
      url: 'http://localhost'
      registration_callback_url: '/registration_callback'
    
    # option overrides
    (@opts[k] = v) for own k, v of opts
    
    # create a simplified version of opts that will be sent over the wire
    @client_opts = {}
    (@client_opts[k] = v) for own k, v of @opts
    delete @client_opts.app_secret
    delete @client_opts.registration
  
    @api = api.get_api_for_app @opts.app_id, @opts.app_secret
  
  get_registration_callback_url : ->
    @opts.url + @opts.registration_callback_url
  
  init: ( server ) ->
    # cookie decoder middleware ( will append fbx_cookie to request )
    server.use cookie.middleware @opts.app_id, @opts.app_secret
    # to serve client-side javascript
    server.use (req, res, next) =>
      # send javascript stub
      if req.url is @opts.script and req.method is 'GET'
        res.headers['Content-Type'] = 'application/javascript'
        res.headers['Cache-Control'] = 'no-cache'
        res.send client.generate_code @client_opts
      else if req.url is @opts.registration_callback_url
        get_signed_request_from_http_request req, (signed_request) =>
          parts = signed_request.split '.'
          sig = util.base64_url_to_base64 parts[0]
          payload = parts[1]
          data = JSON.parse util.base64_url_to_str payload
          # lets verify
          if data.algorithm.toUpperCase() isnt 'HMAC-SHA256'
            res.send 'Unknown algorithm. Expected HMAC-SHA256'
          expected_sig = util.get_hmac_sha256_signature payload, @opts.app_secret
          if sig isnt expected_sig
            console.log 'expected [' + expected_sig + '] got [' + sig + ']'
            res.send 'Signature Check Failed. Payload has been modified'
          else
            if ( rh = @opts.on_registration )?
              rh data, ( redirect_url ) =>
                res.redirect redirect_url || @opts.on_registration_redirect_url
            else
              console.log 'FBX: A user registration happened and there is no registration handler defined'
      else
        next()
  
  get_registration_xfbml : ->
    fields = JSON.stringify @opts.registration.fields
    fields = fields.replace /"/gi, '&quot;'
    '<fb:registration 
      fb_only="true"
      fields="' + fields + '" 
      redirect-uri="' + @get_registration_callback_url() + '"
      width="530">
    </fb:registration>'
  
  # dev-time convenience method. we use it in the examples.
  # you will find yourself visiting this link often to remove the app.
  # so you can register again.
  # you won't be using this in your real app
  get_app_settings_url : ->
    "http://www.facebook.com/settings/?tab=applications&app_id=#{@opts.app_id}"

get_signed_request_from_http_request = (req, cb) ->
  util.get_req_payload req, (payload) ->
    cb querystring.parse(payload).signed_request

exports.create_helper = (opts) -> new Helper opts

###
to debug on the console:
FB.getLoginStatus(function(s){console.log(s)})


logged in to facebook = yes
registered to app = no
session:null, status:'notConnected'

logged in to facebook = no
registered to app = no
session:null, status:'unknown'

logged in to facebook = yes
registered to app = yes
session:{..session.data..}, status:'connected'


these are the state changes we need to cater for:

unknown --> connected = user logged in via facebook popup = reload()
unknown --> notConnected = user logged in, but is not registered to our app = show registration form
connected --> unknown = user logged out

###



