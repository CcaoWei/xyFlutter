import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';

import 'base_request.dart';
import 'client.dart';
import 'exception.dart';
import 'request.dart';
import 'response.dart';
import 'streamed_response.dart';

abstract class BaseClient implements Client {

  Future<Response> head(url, {Map<String, String> headers}) => 
      _sendUnstreamed('HEAD', url, headers);

  Future<Response> get(url, {Map<String, String> headers}) => 
      _sendUnstreamed('GET', url, headers);

  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) => 
      _sendUnstreamed('POST', url, headers, body, encoding);

  Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) => 
      _sendUnstreamed('PUT', url, headers, body, encoding);

  Future<Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) => 
      _sendUnstreamed('PATCH', url, headers, body, encoding);

  Future<Response> delete(url, {Map<String, String> headers, body, Encoding encoding}) =>
      _sendUnstreamed('DELETE', url, headers, body, encoding);
  
  Future<String> read(url, {Map<String, String> headers}) {
    return get(url, headers: headers).then((response) {
      _checkResponseSuccess(url, response);
      return response.body;
    });
  }

  Future<Uint8List> readBytes(url, {Map<String, String> headers}) {
    return get(url, headers: headers).then((response) {
      _checkResponseSuccess(url, response);
      return response.bodyBytes;
    });
  }

  Future<StreamedResponse> send(BaseRequest request);

  Future<Response> _sendUnstreamed(String method, url, Map<String, String> headers, [body, Encoding encoding]) async {
    if (url is String) url = Uri.parse(url);
    var request = Request(method, url);
    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = DelegatingList.typed(body);
      } else if (body is Map) {
        request.bodyFields = DelegatingMap.typed(body);
      } else {
        throw ArgumentError('Invalid request body "$body"');
      }
    }
    return Response.fromStream(await send(request));
  }

  void _checkResponseSuccess(url, Response response) {
    if (response.statusCode < 400) return;
    var message = "Request to $url failed with status ${response.statusCode}";
    if (response.reasonPhrase != null) {
      message = "$message: ${response.reasonPhrase}";
    }
    if (url is String) url = Uri.parse(url);
    throw ClientException("$message.", url);
  }

  void close() {}
}