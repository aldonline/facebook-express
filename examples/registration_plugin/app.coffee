facebook_express = require '../../lib/facebook-express'
express = require 'express'
config = require '../../config'

server = express.createServer()
server.register '.coffee', require 'coffeekup'
server.set 'view engine', 'coffee'
server.use express.staticProvider __dirname + '/public'
# server.use express.bodyDecoder()

# create a facebook app helper
fbx = facebook_express.create_helper
  app_id: config.app_id
  app_secret: config.app_secret
  domain: config.domain
  url: 'http://' + config.domain
  registration:
    fields: [
      {name:'name'}
      {name:'email'}
      {name:'location'}
      {name:'gender'}
      {name:'password', view:'not_prefilled'}
      {name:'entrepreneur', description:'Are you an Entrepreneur?', type:'checkbox',  default:'checked'}
      {name:'investor', description:'Are you an Investor?', type:'checkbox'}
      {name:'developer', description:'Are you a Developer?', type:'checkbox'}
    ]
  on_registration : ( data, cb ) ->
    console.log 'got registration data. it was really easy.'
    console.log data
    cb '/'

# we need to setup some middleware on our server
# this will set up some routes ( for example /__fbx.js, /registration_callback, etc )
fbx.init server

server.get '/', (req, res) ->
  res.render 'index', layout: no

server.get '/register', (req, res) ->
  res.render 'register', layout: no, context:{fbx:fbx}

server.listen 80