express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
soap = require 'soap'

app = express.createServer()
app.use assets()
app.use '/img', express.static "#{__dirname}/assets/img"
app.use '/js', express.static "#{__dirname}/assets/js"
app.set 'view engine', 'jade'

app.get '/', (req, resp) -> resp.render 'index'

app.get '/releases', (req, resp) ->
  args = (
    'in0': req.query.username
    'in1': req.query.password
  )
  
  soap.createClient req.query.wsdl, (err, client) ->
    client.login args, (err, result) ->
      if !err
        args = (
          'in0': result.loginReturn
          'in1': req.query.project
        )
        client.getVersions args, (err, result) ->
          console.log result
      
  # client.getVersions 
  resp.send 'hi ajax'

app.listen process.env.VMC_APP_PORT or 3000, -> console.log 'Listening...'