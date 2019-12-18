import 'dart:async';

import 'byte_stream.dart';
import 'base_response.dart';
import 'base_request.dart';
import 'utils.dart';

class StreamedResponse extends BaseResponse {

  final ByteStream stream;

  StreamedResponse(
    Stream<List<int>> stream,
    int statusCode,
    {int contentLength,
     BaseRequest request,
     Map<String, String> headers: const {},
     bool isRedirect: false,
     bool persistentConnection: true,
     String reasonPhrase})
    : this.stream = toByteStream(stream),
      super(
        statusCode,
        contentLength: contentLength,
        request: request,
        headers: headers,
        isRedirect: isRedirect,
        persistentConnection:persistentConnection,
        reasonPhrase: reasonPhrase
      );
}