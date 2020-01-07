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
      [Map<String, dynamic> params, Map<String, String> files]) async {
    var request = await _openRequest(url);

    files == null
        ? _writeJson(request, params)
        : _writeMultipart(request, params, files);

    var response = await request.close();

    await for (var s in response.transform(Utf8Decoder())) {
      return s;
    }

    throw HttpClientError('Something went wrong with the request.');
  }

  Future<HttpClientRequest> _openRequest(String url) {
    if (_client != null) {
      return _client.postUrl(Uri.parse(url));
    } else {
      var c = HttpClient();
      var r = c.postUrl(Uri.parse(url));
      c.close();
      return r;
    }
  }

  void _writeJson(HttpClientRequest request, Map<String, dynamic> params) {
    request.headers.add('content-type', 'application/json; charset=utf-8');
    request.write(json.encode(params));
  }

  void _writeMultipart(HttpClientRequest request, Map<String, dynamic> params,
      Map<String, String> files) {
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
      var f = File(e.value);
      body += String.fromCharCodes(f.readAsBytesSync());
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
