import 'dart:convert';
import 'dart:io';

import 'dart:math';

class HttpHandler {
  HttpClient _client;

  void start() => _client = HttpClient();
  void close() {
    if (_client == null) {
      throw HttpClientError('Http handler is already closed');
    }
    _client.close();
    _client = null;
  }

  Future<String> post(String url,
      [Map<String, dynamic> data]) async {
    var params = <String, dynamic>{};
    var files = <String, File>{};

    if(data != null) data.forEach((k,v) => v is File ? files[k] = v : params[k] = v);

    var request = await _openRequest('post', url);

    files.isEmpty
        ? _writeJson(request, params)
        : _writeMultipart(request, params, files);

    var response = await request.close();

    await for (var s in response.transform(Utf8Decoder())) {
      return s;
    }

    throw HttpClientError('Something went wrong with the request.');
  }

  Future<void> download(String url, String path) async {
    var request = await _openRequest('get', url);

    var response = await request.close();

    await response.pipe(File(path).openWrite());
  }

  Future<HttpClientRequest> _openRequest(String method, String url) {
    if (_client != null) {
      return _client.openUrl(method, Uri.parse(url));
    } else {
      var c = HttpClient();
      var r = c.openUrl(method, Uri.parse(url));
      c.close();
      return r;
    }
  }

  void _writeJson(HttpClientRequest request, Map<String, dynamic> params) {
    request.headers.add('content-type', 'application/json; charset=utf-8');
    request.write(json.encode(params));
  }

  void _writeMultipart(HttpClientRequest request, Map<String, dynamic> params,
      Map<String, File> files) {
    var boundary =
        '----dartgram--' + Random().nextInt(4294967296).toString().padLeft(10);

    request.headers
        .set('Content-Type', 'multipart/form-data; boundary=$boundary');

    var body = '';

    for (var e in params.entries) {
      body +=
          '--$boundary\r\nContent-Disposition: form-data; name="${e.key}"\r\n\r\n${e.value}\r\n';
    }

    for (var e in files.entries) {
      body +=
          '--$boundary\r\nContent-Disposition: form-data; name="${e.key}"; filename="${e.key}"\r\n\r\n';
      var file = e.value;
      body += String.fromCharCodes(file.readAsBytesSync());
      body += '\r\n';
    }

    body += '--$boundary--';

    request.write(body);
  }
}

class HttpClientError implements Exception {
  String cause;
  HttpClientError(this.cause);
}
