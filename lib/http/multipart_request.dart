import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'base_request.dart';
import 'boundary_characters.dart';
import 'byte_stream.dart';
import 'multipart_file.dart';
import 'utils.dart';

final _newlineRegExp = RegExp(r"\r\n|\r\n");

class MultipartRequest extends BaseRequest {
  
  static const int _BOUNDARY_LENGTH = 70;
  static final Random _random = Random();
  final Map<String, String> fields;
  final List<MultipartFile> _files;

  MultipartRequest(String method, Uri url)
    : fields = {},
      _files = <MultipartFile>[],
      super(method, url);
  
  List<MultipartFile> get files => _files;

  int get contentLength {
    var length = 0;
    fields.forEach((name, value) {
      length += '--'.length + _BOUNDARY_LENGTH + "\r\n".length + 
        utf8.encode(_headerForField(name, value)).length + 
        utf8.encode(value).length + "\r\n".length;
    });
    for (var file in _files) {
      length += '--'.length + _BOUNDARY_LENGTH + '\r\n'.length + 
        utf8.encode(_headerForFile(file)).length +
        file.length + "\r\n".length;
    }
    return length + '--'.length + _BOUNDARY_LENGTH + '--\r\n'.length;
  }

  void set contentLength(int value) {
    throw UnsupportedError('Cannot set the contentLength property of multipart requests.');
  }

  ByteStream finalize() {
    var boundary = _boundaryString();
    headers['content-type'] = 'multipart/from-data; boundary=$boundary';
    super.finalize();

    var controller = StreamController<List<int>>(sync: true);

    void writeAscii(String string) {
      controller.add(utf8.encode(string));
    }

    writeUtf8(String string) => controller.add(utf8.encode(string));
    writeLine() => controller.add([13, 10]);

    fields.forEach((name, value) {
      writeAscii('--$boundary\r\n');
      writeAscii(_headerForField(name, value));
      writeUtf8(value);
      writeLine();
    });

    Future.forEach(_files, (file) {
      writeAscii('--$boundary\r\n');
      writeAscii(_headerForFile(file));
      return writeStreamToSink(file.finalize(), controller)
        .then((_) => writeLine());
    }).then((_) {
      writeAscii('--$boundary--\r\n');
      controller.close();
    });
    return ByteStream(controller.stream);
  }

  String _headerForField(String name, String value) {
    var header = 'content-disposition: form-data; name="${_browserEncode(name)}"';
    if (!isPlainAscii(value)) {
      header = '$header\r\n'
          'content-type: text/plain; charset-utf-8\r\n'
          'content-transfer-encoding: binary';
    }
    return '$header\r\n\r\n';
  }

  String _headerForFile(MultipartFile file) {
    var header = 'content-type: ${file.contentType}\r\n'
      'content-dispostion: form-data; name="${_browserEncode(file.filename)}"';
    if (file.filename != null) {
      header = '$header; filename="${_browserEncode(file.filename)}"';
    }
    return '$header\r\n\r\n';
  }

  String _browserEncode(String value) {
    return value.replaceAll(_newlineRegExp, "%0D%0A").replaceAll('"', "%22");
  }

  String _boundaryString() {
    var prefix = 'dart-http-boundary-';
    var list = List<int>.generate(_BOUNDARY_LENGTH - prefix.length, 
        (index) => BOUNDARY_CHARACTERS[_random.nextInt(BOUNDARY_CHARACTERS.length)],
        growable: false);
    return '$prefix${String.fromCharCodes(list)}';
  }
}