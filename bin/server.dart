import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory;

VirtualDirectory virDir;

String webDir = Platform.script.resolve('../web/').toFilePath();

void handleRequest(HttpRequest req) {

  bool requestServed = false;

  if (req.uri.path == '/index.html') {
    req.response
      ..headers.add('HTTP/1.1', '301 Moved Permanently')
      ..headers.add('Location', '/')
      ..statusCode = 301
      ..close();
    requestServed = true;
  }

  if (req.uri.path == '/') {
    var indexUri = new Uri.file(webDir).resolve('index.html');
    virDir.serveFile(new File(indexUri.toFilePath()), req);
    requestServed = true;
  }

  if (!requestServed) {
    virDir.serveRequest(req);
  }

}

void main() {
  virDir = new VirtualDirectory(webDir);
  HttpServer.bind('0.0.0.0', 8080).then((HttpServer server) {
    server.listen((HttpRequest request) {
      handleRequest(request);
    });
  });
}

