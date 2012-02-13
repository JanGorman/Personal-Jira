bogart = require 'express'

class PersonalJira

  app = express.createServer()

  app.get '/', (req, res) ->
    res.send 'hello world'

  app.listen 3000

module.exports = PersonalJira