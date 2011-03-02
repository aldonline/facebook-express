doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    script src:'/assets/jquery-1.5.1.min.js'
    script src:'/__fbx.js'
  body ->
    header ->
    text @fbx.get_registration_xfbml()