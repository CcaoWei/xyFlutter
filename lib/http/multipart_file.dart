import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import 'byte_stream.dart';
import 'utils.dart';

class MultipartFile {

  final String field;
  final int length;
  final String filename;
  final MediaType contentType;
  final ByteStream _stream;
  
  bool _isFinalized = false;
  bool get isFinalized => _isFinalized;

  MultipartFile(this.field, Stream<List<int>> stream, this.length, 
    {this.filename, MediaType contentType})
    : this._stream = toByteStream(stream),
      this.contentType = contentType != null ? contentType : MediaType('application', 'octet-stream');

  factory MultipartFile.fromBytes(String field, List<int> value, 
    {String filename, MediaType contentType}) {
    var stream = ByteStream.fromBytes(value);
    return MultipartFile(field, stream, value.length, filename: filename, contentType: contentType);
  }

  factory MultipartFile.fromString(String field, String value, 
    {String filename, MediaType contentType}) {
    contentType = contentType == null ? MediaType('text', 'plain') : contentType;
    var encoding = encodingForCharset(contentType.parameters['charset'], utf8);
    contentType = contentType.change(parameters: {'charset': encoding.name});
    return MultipartFile.fromBytes(field, encoding.encode(value), filename: filename, contentType: contentType);
  }

  static Future<MultipartFile> fromPath(String field, String filePath, 
    {String filename, MediaType contentType}) async {
    if (filename == null) {
      filename = path.basename(filePath);
    }
    var file = File(filePath);
    var length = await file.length();
    var stream = ByteStream(DelegatingStream.typed(file.openRead()));
    return MultipartFile(field, stream, length, filename: filename, contentType: contentType);
  }

  ByteStream finalize() {
    if (isFinalized) {
      throw StateError("Can't finalize a finalized MultipartFile");
    }
    _isFinalized = true;
    return _stream;
  }
}