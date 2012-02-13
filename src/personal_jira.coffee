bogart = require 'bogart'

class PersonalJira

  router = bogart.router();

  router.get '/', ->
    bogart.html 'hello world'

  bogart.start app

module.exports = PersonalJira