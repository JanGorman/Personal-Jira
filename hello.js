var bogart = require('bogart');

var router = bogart.router();

router.get('/', function() {
  return bogart.html('Hello World');
});

var app = bogart.app();
app.use(bogart.batteries);
app.use(router);

app.start();