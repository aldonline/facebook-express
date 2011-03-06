# client side code

client_side_code = -> # this function defines the base scope
  fyi = (msg) -> console.log msg

  fb_status = null # holds current (last) status
  $ = jQuery

  opts = OPTS # <-- 'OPTS' will get replaced before sending over the wire

  load_script = ->
    fb_root = $ '#fb-root'
    if fb_root.length is 0
      fb_root = $('<div>', id:'fb-root').appendTo $ 'body'
    fb_root.append $ '<script>', src:"http://connect.facebook.net/#{opts.locale}/all.js", async:yes

  set_status = ( status ) ->
    # update CSS
    body = $ 'body'
    body.removeClass 'fbx_initial fbx_connected fbx_unknown fbx_notConnected'
    body.addClass "fbx_#{status}" if status?
    
    transition = "#{fb_status or 'null'} -> #{status}"
    switch transition
      when 'unknown -> connected' then reload()
      # unknown -> notConnected is not being detected
      # via subscribing to auth.sessionChange
      # we need an alternative method
      # ( for example, pulling on an interval )
      when 'unknown -> notConnected ' then location.href = '/register' # <-- KLUDGE: URL is hardcoded
      when 'connected -> unknown' then reload()
      when 'notConnected -> unknown' then reload()
    # store new status
    fb_status = status

  window.fbAsyncInit = ->
    FB.init appId: opts.app_id, status: on, cookie: on, xfbml: on
    FB.getLoginStatus (res) ->
      set_status res.status
      FB.Event.subscribe 'auth.sessionChange', (res) ->
        set_status res.status

  $ ->
    $('body').addClass 'fbx_initial'
    # client-side opts overrides
    ( opts[k] = v ) for k, v of window.__fbx if window.__fbx?
    load_script()
  
  reload = -> 
    window.location.reload()

exports.generate_code = (opts) ->
  code = client_side_code.toString()
  code = code.replace 'OPTS', JSON.stringify opts
  "(#{code})();"