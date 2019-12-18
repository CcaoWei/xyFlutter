import 'dart:async';

import 'base_client.dart';
import 'base_request.dart';
import 'byte_stream.dart';
import 'request.dart';
import 'response.dart';
import 'streamed_response.dart';

class MockClient extends BaseClient {

  final MockClientStreamHandler _handler;

  MockClient._(this._handler);

  MockClient(MockClientHanler fn)
    : this._((baseRequest, bodyStream) {
      return bodyStream.toBytes().then((bodyBytes) {
        var request = Request(baseRequest.method, baseRequest.url)
              ..persistentConnection = baseRequest.persistentConnection
              ..followRedirects = baseRequest.followRedirects
              ..maxRedirects = baseRequest.maxRedirects
              ..headers.addAll(baseRequest.headers)
              ..bodyBytes = bodyBytes
              ..finalize();
        return fn(request);
      }).then((response) {
        return StreamedResponse(
          ByteStream.fromBytes(response.bodyBytes),
          response.statusCode,
          contentLength: response.contentLength,
          request: baseRequest,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase
        );
      });
    });

  MockClient.stream(MockClientStreamHandler fn)
    : this._((request, bodyStream) {
      return fn(request, bodyStream).then((response) {
        return StreamedResponse(
          response.stream,
          response.statusCode,
          contentLength: response.contentLength,
          request: request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase
        );
      });
    });

  Future<StreamedResponse> send(BaseRequest request) async {
    var bodyStream = request.finalize();
    return await _handler(request, bodyStream);
  }
}

typedef Future<StreamedResponse> MockClientStreamHandler(BaseRequest request, ByteStream bodyStream);

typedef Future<Response> MockClientHanler(Request request);