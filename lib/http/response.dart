import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

import 'base_request.dart';
import 'base_response.dart';
import 'streamed_response.dart';
import 'utils.dart';

class Response extends BaseResponse {

  final Uint8List bodyBytes;

  String get body => _encodingForHeaders(headers).decode(bodyBytes);

  Response(
      String body,
      int statusCode,
      {BaseRequest request,
       Map<String, String> headers: const {},
       bool isRedirect: false,
       bool persistentConnection: true,
       String reasonPhrase}
  ) : this.bytes(
    _encodingForHeaders(headers).encode(body),
    statusCode,
    request: request,
    headers: headers,
    isRedirect: isRedirect,
    persistentConnection: persistentConnection,
    reasonPhrase: reasonPhrase
  );

  Response.bytes(
    List<int> bodyBytes,
    int statusCode,
    {BaseRequest request,
     Map<String, String> headers: const {},
     bool isRedirect: false,
     bool persistentConnection: true,
     String reasonPhrase}
  ) : bodyBytes = toUint8List(bodyBytes),
      super(
        statusCode,
        contentLength: bodyBytes.length,
        request: request,
        headers: headers,
        isRedirect: isRedirect,
        persistentConnection: persistentConnection,
        reasonPhrase: reasonPhrase
      );

  static Future<Response> fromStream(StreamedResponse response) {
    return response.stream.toBytes().then((body) {
      return Response.bytes(
        body,
        response.statusCode,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase
      );
    });
  }
}

Encoding _encodingForHeaders(Map<String, String> headers) => 
  encodingForCharset(_contentTypeForHeaders(headers).parameters['charset']);

MediaType _contentTypeForHeaders(Map<String, String> headers) {
  var contentType = headers['content-type'];
  if (contentType != null) return MediaType.parse(contentType);
  return MediaType('application', 'octet-stream');
}