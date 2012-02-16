express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
soap = require 'soap'
util = require 'util'
exec = require('child_process').exec

app = express.createServer()
app.use assets()
app.use '/img', express.static "#{__dirname}/assets/img"
app.set 'view engine', 'jade'

app.get '/', (req, resp) -> resp.render 'index'

app.get '/releases', (req, resp) ->
  soap.createClient req.query.wsdl, (err, client) ->
    client.login ('in0': req.query.username, 'in1': req.query.password), (err, result) ->
      if !err
        child = exec "python get_versions.py --token #{result.loginReturn} --project #{req.query.project} --wsdl #{req.query.wsdl}", (err, stdout, stderr) ->
          if err == null
            resp.send stdout
          else
            resp.send 'fail'
  
app.get '/issues', (req, resp) ->
  soap.createClient req.query.wsdl, (err, client) ->
    client.login ('in0': req.query.username, 'in1': req.query.password), (err, result) ->
      console.log result
      if !err
        child = exec "python get_issues.py --token #{result.loginReturn} --username #{req.query.username} --wsdl #{req.query.wsdl} --release #{req.query.release}", (err, stdout, stderr) ->
          if err == null
            resp.send stdout
          else
            resp.send 'fail'

app.listen process.env.VMC_APP_PORT or 3000, -> console.log 'Listening...'