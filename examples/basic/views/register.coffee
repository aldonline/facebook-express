doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    script src:'/assets/jquery-1.5.1.min.js'
    script src:'/__fbt.js'
  body ->
    header ->
    text @fbapp.get_registration_xfbml()