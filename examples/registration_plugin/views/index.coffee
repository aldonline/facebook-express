doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    script src:'/assets/jquery-1.5.1.min.js'
    script src:'/__fbx.js'
    style '''
    body {
      font-family: verdana ;
      color: grey;
    }
    body.fbx_connected {
      color: green;
    }
    body.fbx_notConnected {
      color: red;
    }
    body.fbx_unknown {
      color: orange;
    }

    '''
  body ->
    header ->
      h1 'Hello World'
      text '<fb:login-button
              autologoutlink="true"
              registration-url="http://localhost.local/register" 
              fb-only="true"
              ></fb:login-button>'
      br()
      a href: @fbx.get_app_settings_url(), ->
        'Go to Application Settings on Facebook.com'