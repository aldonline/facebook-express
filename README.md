Facebook Express
=============================================

Getting Started
--------------------

### Install

npm install facebook-toolkit

### Use

On the server side of things

    # import the toolkit
    fbt = require 'facebook-toolkit'

    # create facebook app with minimum options
    app = new fbt.App app_id:'yourid', app_secret:'your app secret'

    # initialize express server ( will setup some middleware )
    app.init server

On the client

    <html>
      <head>
        <script src="/__fbt.js"></script>
      </head>
      <body></body>
    </html>

And that's it ;)

It will setup everything for you. Everything. You now have a basic Facebook integration setup.

Of course, there are many different ways of setting up your Facebook integration.

There are different levels of configuration. On an higher level, you can choose from a variety of pre-built, best practices integration scenarios.

Configuration
-------------

### locale
default value: 'en_US'
can be set on server and client

script
default value: '__fbt.js'
can be set on server


Low Level Features
------------------

### Access the Facebook cookie


