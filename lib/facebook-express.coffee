###
server side facebook logic
###

http = require 'http'
URL = require 'url'
request = require 'request'
events = require 'events'

cookie = require './cookie'
client = require './client'
api = require './api'

class App extends events.EventEmitter
  constructor: ( opts ) ->
    # base options
    @opts =
      script: '/__fbt.js'
      locale: 'en_US'
    
    # option overrides
    (@opts[k] = v) for own k, v of opts
    
    # create a simplified version of opts that will be sent over the wire
    @client_opts = {}
    (@client_opts[k] = v) for own k, v of @opts
    delete @client_opts.app_secret
    delete @client_opts.registration
  
    @api = api.get_api_for_app @opts.app_id, @opts.app_secret
  
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
      else if req.url is '/log'
        console.log req
        res.send 'log!'
      else
        next()
  
  get_registration_xfbml : ->
    fields = JSON.stringify @opts.registration.fields
    fields = fields.replace /"/gi, '&quot;'
    '<fb:registration 
      fb_only="true"
      fields="' + fields + '" 
      redirect-uri="http://localhost/"
      width="530">
    </fb:registration>'


exports.create_app = (opts) -> new App opts


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



