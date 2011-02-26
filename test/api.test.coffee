require 'coffee-script'
assert = require 'assert'

api = require '../lib/api'

app_id = process.env.FB_APP_ID
app_secret = process.env.FB_APP_SECRET

x = exports

x.test_env_vars = ->
  assert.ok app_id? , 'You must set the FB_APP_ID env variable with your Facebook app id in order to run tests'
  assert.ok app_secret? , 'You must set the FB_APP_SECRET env variable with your Facebook app id in order to run tests'

x.test_get_app_token = ->
  api.get_app_access_token app_id, app_secret, (err, res) ->
    if err?
      console.log err
      assert.ok false, 'Error must be null'
    assert.ok res?, 'Result must be non null'
    assert.equal res.indexOf(app_id + '|') , 0, "Access token must start with app_id + | . ( #{res} )"

x.test_get_app_token_invalid_app_id = ->
  api.get_app_access_token 'invalid app id', app_secret, (err, res) ->
    assert.equal res, null
    assert.ok err?

x.test_api_call = ->
  a = api.get_api_for_app app_id, app_secret
  a '/aldo.bucchi', (res) ->
    console.log res