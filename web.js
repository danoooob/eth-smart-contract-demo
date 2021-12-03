var http = require('http');
var fs = require('fs');


var server = http.createServer(function (request, response) {
    url_ = request.url == '/'?'index.html':request.url
    fs.readFile('./web/' + url_, function(err, data) {
        if (!err) {
            var dot_offset = url_.lastIndexOf('.');
            var minetype = dot_offset == -1?'text/plan':{
                '.html' : 'text/html',
                '.js' : 'text/javascript'
            }[url_.substr(dot_offset)];
            response.setHeader('Content-Type', minetype);
            response.end(data);
        } else {
            console.log('file not found: ' + request.url);
            response.writeHead(404, 'Not Found');
            response.end();
        }
    })
})


server.listen(8000);

console.log('Server running at http://localhost:8000/')