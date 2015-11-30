var express = require('express');
var app = express();

app.set('port', (process.env.PORT || 7474));

app.use(express.static(__dirname + '/dist'));

app.listen(app.get('port'), function() {
    console.log('Neo4j browser is running on port', app.get('port'));
});

//app.listen(app.get('port'), "localhost");
