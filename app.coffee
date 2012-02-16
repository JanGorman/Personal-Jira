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
  args = (
    'in0': req.query.username
    'in1': req.query.password
  )
  
  soap.createClient req.query.wsdl, (err, client) ->
    client.login args, (err, result) ->
      if !err
        child = exec "python get_versions.py --token #{result.loginReturn} --project #{req.query.project} --wsdl #{req.query.wsdl}", (err, stdout, stderr) ->
          if err == null
            resp.send stdout
          else
            resp.send 'fail'
  
app.get '/issues', (req, resp) ->
  soap.createClient req.query.wsdl, (err, client) ->
    client.login ('in0': req.query.username, 'in1': req.query.password), (err, result) ->
      if !err
        args = (
          'in0': result.loginReturn
          'in1': "assignee = '#{req.query.username}' AND fixVersion = #{req.query.release}"
          'in2': 100 
        )
        client.getIssuesFromJqlSearch args, (err, result) ->
          console.log result
      else
        resp.send 'fail'

app.listen process.env.VMC_APP_PORT or 3000, -> console.log 'Listening...'