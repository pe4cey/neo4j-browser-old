var express = require('express');
var app = express();

app.set('port', (process.env.PORT || 5000));

app.use(express.static(__dirname + '/dist/browser'));

app.get('/', function(request, response) {
    response.render('/dist/browser/index.html');
});

app.listen(app.get('port'), function() {
    console.log('Neo4j browser is running on port', app.get('port'));
});
