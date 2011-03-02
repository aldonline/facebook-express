facebook_express = require '../../lib/facebook-express'
express = require 'express'
config = require '../../config'

server = express.createServer()
server.register '.coffee', require 'coffeekup'
server.set 'view engine', 'coffee'
server.use express.staticProvider __dirname + '/public'

# create a facebook app helper
fbx = new facebook_express.create_app
  app_id: config.app_id
  app_secret: config.app_secret
  domain: config.domain

# we need to setup some middleware on our server
fbx.init server

server.get '/', (req, res) ->
  res.render 'index', layout: no

server.listen 80