Facebook Express
=============================================

THIS IS A REALLY OLD MODULE. DON'T USE IT. EXPRESS HAS COME A LONG WAY SINCE.

Getting Started
--------------------

### Install

    npm install facebook-express

### Use

On the server side of things

    fbx = require 'facebook-express'

    # create facebook app with minimum options
    app = new fbx.App app_id:'yourid', app_secret:'your app secret'

    # initialize express server ( will setup some middleware )
    app.init server

On the client

    <html>
      <head>
        <script src="/__fbx.js"></script>
      </head>
      <body></body>
    </html>

And that's it ;)

It will setup everything for you. Everything. You now have a basic Facebook integration setup.

Of course, there are many different ways of setting up your Facebook integration.

There are different levels of configuration. On an higher level, you can choose from a variety of pre-built, best practices integration scenarios.

On a lower level, you have access all the necessary routines and functions to implement a variety of solutions.

Configuration
-------------

### locale
default value: 'en_US'
can be set on server and client

script
default value: '__fbx.js'
can be set on server


Low Level Features
------------------

### Access the Facebook cookie


