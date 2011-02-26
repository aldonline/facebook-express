# client side code

client_side_code = -> # this function defines the base scope
  fyi = (msg) -> console.log msg

  fb_status = null
  $ = jQuery

  opts = OPTS # <-- 'OPTS' will get replaced before sending over the wire
  
  load_script = ->
    fb_root = $ '#fb-root'
    if fb_root.length is 0
      fb_root = $('<div>', id:'fb-root').appendTo $ 'body'
    fb_root.append $ '<script>', src:"http://connect.facebook.net/#{opts.locale}/all.js", async:yes

  window.fbAsyncInit = ->
    FB.init appId: opts.app_id, status: on, cookie: on, xfbml: on
    FB.getLoginStatus (res) ->
      fb_status = res.status
      fyi 'initial status'
      fyi res
      unless res.status is 'connected'
        $('#fb-login-button').css display: 'block'
      FB.Event.subscribe 'auth.sessionChange', (res) ->
        fyi 'status changed:'
        if res.status isnt fb_status
          fyi "and is different than initial status #{fb_status}"
          fyi res
          window.location.reload()
  $ ->
    # client-side opts overrides
    ( opts[k] = v ) for k, v of window.__fbt if window.__fbt?
    load_script()

exports.generate_code = (opts) ->
  code = client_side_code.toString()
  code = code.replace 'OPTS', JSON.stringify opts
  "(#{code})();"