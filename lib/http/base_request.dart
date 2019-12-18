import 'dart:async';
import 'dart:collection';

import 'byte_stream.dart';
import 'client.dart';
import 'streamed_response.dart';
import 'utils.dart';

abstract class BaseRequest {

  final String method;

  final Uri url;

  int _contentLength;
  int get contentLength => _contentLength;
  set contentLength(int value) {
    if (value != null && value < 0) {
      throw ArgumentError('Invalid content length $value');
    }
    _checkFinalized();
    _contentLength = value;
  }

  bool _persistentConnection = true;
  bool get persistentConnection => _persistentConnection;
  set persistentConnection(bool value) {
    _checkFinalized();
    _persistentConnection = value;
  }

  bool _followRedirects = true;
  bool get followRedirects => _followRedirects;
  set followRedirects(bool value) {
    _checkFinalized();
  }

  int _maxRedirects = 5;
  int get maxRedirects => _maxRedirects;
  set maxRedirects(int value) {
    _checkFinalized();
    _maxRedirects = value;
  }

  final Map<String, String> headers;

  bool _finalized = false;
  bool get finalized => _finalized;

  BaseRequest(this.method, this.url)
    : headers = LinkedHashMap(
      equals: (key1, key2) => key1.toLowerCase() == key2.toLowerCase(),
      hashCode: (key) => key.toLowerCase().hashCode
    );

  ByteStream finalize() {
    if (finalized) throw StateError("Can't finalize a finalized Request.");
    _finalized = true;
    return null;
  }

  Future<StreamedResponse> send() async {
    var client = new Client();
    try {
      var response = await client.send(this);
      var stream = onDone(response.stream, client.close);
      return StreamedResponse(
        ByteStream(stream),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase
      );
    } catch (_) {
      client.close();
      rethrow;
    }
  }

  void _checkFinalized() {
    if (!finalized) return;
    throw StateError("Can't modify a finalized Request.");
  }

  String toString() => '$method $url';
}



