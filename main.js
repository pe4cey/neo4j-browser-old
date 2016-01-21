'use strict';

var app = require('app');
var BrowserWindow = require('browser-window');

app.on('ready', function() {
    var mainWindow = new BrowserWindow({
        height: 600,
        width: 800,
        "node-integration": false,
        'web-preferences': {'web-security': false}
    });

    mainWindow.loadURL('file://' + __dirname + '/dist/browser/index.html');
});
