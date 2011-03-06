crypto = require 'crypto'

get_req_payload = (req, cb) ->
  if req.rawBody? # this happens when connect's bodyDecoder middleware is set
    cb req.rawBody
  req.setEncoding 'utf8'
  data = ''
  req.on 'data', (chunk) -> data += chunk
  req.on 'end', -> cb data

base64_to_str = (str) -> ( new Buffer str || '', 'base64' ).toString "ascii"

base64_url_to_str = (str) -> base64_to_str base64_url_to_base64 str

base64_url_to_base64 = (str) -> 
  ( str = str + '=' ) for i in [0...(4 - str.length%4)]
  str.replace(/\-/g, '+').replace(/_/g, '/')

get_hmac_sha256_signature = ( payload, secret ) ->
  hmac = crypto.createHmac 'sha256', secret
  hmac.update payload
  hmac.digest 'base64'


exports.get_req_payload = get_req_payload
exports.base64_to_str = base64_to_str
exports.base64_url_to_str = base64_url_to_str
exports.base64_url_to_base64 = base64_url_to_base64
exports.get_hmac_sha256_signature = get_hmac_sha256_signature