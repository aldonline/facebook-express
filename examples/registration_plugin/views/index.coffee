doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    script src:'/assets/jquery-1.5.1.min.js'
    script src:'/__fbx.js'
  body ->
    header ->
      h1 'Hello World'
      text '<fb:login-button id="fb-login-button"
              autologoutlink="true"
              registration-url="http://localhost.local/register" 
              fb-only="true"
              style="display:block"
              ></fb:login-button>'