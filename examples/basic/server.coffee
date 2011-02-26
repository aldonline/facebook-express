fbt = require '../../lib/facebook-toolkit'
express = require 'express'

server = express.createServer()
server.register '.coffee', require 'coffeekup'
server.set 'view engine', 'coffee'
server.use express.staticProvider __dirname + '/public'

# create a facebook app helper
fbapp = new fbt.create_app
  app_id: process.env.FB_APP_ID
  app_secret: process.env.FB_APP_SECRET
  domain: 'localhost'
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

# we need to setup some middleware on our server
fbapp.init server

server.get '/', (req, res) ->
  res.render 'index', layout: no

server.get '/register', (req, res) ->
  res.render 'register', layout: no, context:{fbapp:fbapp}

server.listen 80