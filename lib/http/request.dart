import 'dart:convert';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

import 'base_request.dart';
import 'byte_stream.dart';
import 'utils.dart';

class Request extends BaseRequest {

  int get contentLength => bodyBytes.length;

  set contentLength(int value) {
    throw UnsupportedError('Cannot set the contentLength property of non-streaming Request objects');
  }

  Encoding _defaultEncoding;

  Encoding get encoding {
    if (_contentType == null || !_contentType.parameters.containsKey('charset')) {
      return _defaultEncoding;
    }
    return requiredEncodingForCharset(_contentType.parameters['charset']);
  }

  set encoding(Encoding value) {
    _checkFinalized();
    _defaultEncoding = value;
    var contentType = _contentType;
    if (contentType == null) return;
    _contentType = contentType.change(parameters: {'charset': value.name});
  }

  Uint8List get bodyBytes => _bodyBytes;
  Uint8List _bodyBytes;

  set bodyBytes(List<int> value) {
    _checkFinalized();
    _bodyBytes = toUint8List(value);
  }

  String get body => encoding.decode(bodyBytes);

  set body(String value) {
    bodyBytes = encoding.encode(value);
    var contentType = _contentType;
    if (contentType == null) {
      _contentType = MediaType('text', 'plain', {'charset': encoding.name});
    } else if (!contentType.parameters.containsKey('charset')) {
      _contentType = contentType.change(parameters: {'charset': encoding.name});
    }
  }

  Map<String, String> get bodyFields {
    var contentType = _contentType;
    if (contentType == null || contentType.mimeType != 'application/x-www-form-unlencoded') {
      throw StateError('Cannot access the body fields of a Request without content-type "application/x-www-form-urlencoded".');
    }
    return Uri.splitQueryString(body, encoding: encoding);
  }

  set bodyFields(Map<String, String> fields) {
    var contentType = _contentType;
    if (contentType == null) {
      _contentType = MediaType('application', 'x-www-form-urlencoded');
    } else if (contentType.mimeType != 'application/x-www-form-urlencoded') {
      throw StateError('Cannot set the body fields of a Request with content-type "${contentType.mimeType}".');
    }
    this.body = mapToQuery(fields, encoding: encoding);
  }

  Request(String method, Uri url)
    : _defaultEncoding = utf8,
      _bodyBytes = Uint8List(0),
      super(method, url);

  ByteStream finalize() {
    super.finalize();
    return ByteStream.fromBytes(bodyBytes);
  }

  MediaType get _contentType {
    var contentType = headers['content-type'];
    if (contentType == null) return null;
    return MediaType.parse(contentType);
  }

  set _contentType(MediaType value) {
    headers['content-type'] = value.toString();
  }

  void _checkFinalized() {
    if (!finalized) return;
    throw StateError("Can't mofify a finalized Request");
  }
}