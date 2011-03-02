try
  localconfig = require './localconfig'
catch error
  # should we use stderr?
  console.log '''

  ########################################  
  ########################################

  ERROR: Missing Local Configuration File.
  ---------------------------------------
  Please create a file named localconfig.coffee and store it in the root 
  of this project, alongside the start.sh script you just executed.
  Inside this file, copy paste the following 4 lines of code:

  exports.get_config = ->
    app_id: "111111111111"
    app_secret: "111111111111111"
    domain: "localhost"

  ########################################  
  ########################################
  '''
  process.exit 1

module.exports = localconfig.get_config()