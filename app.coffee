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
  resp.send 'hi'

app.listen process.env.VMC_APP_PORT or 3000, -> console.log 'Listening...'