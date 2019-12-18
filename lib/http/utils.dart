import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'byte_stream.dart';

String mapToQuery(Map<String, String> map, {Encoding encoding}) {
  var pairs = <List<String>>[];
  map.forEach((key, value) => 
    pairs.add([Uri.encodeQueryComponent(key, encoding: encoding),
               Uri.encodeQueryComponent(value, encoding:  encoding)]));
  return pairs.map((pair) => '${pair[0]}=${pair[1]}').join('&');
}

List<String> split1(String toSplit, String pattern) {
  if (toSplit.isEmpty) return <String>[];
  var index = toSplit.indexOf(pattern);
  if (index == -1) return [toSplit];
  return [
    toSplit.substring(0, index),
    toSplit.substring(index + pattern.length)
  ];
}

Encoding encodingForCharset(String charset, [Encoding fallback = latin1]) {
  if (charset == null) return fallback;
  var encoding = Encoding.getByName(charset);
  return encoding == null ? fallback : encoding;
}

Encoding requiredEncodingForCharset(String charset) {
  var encoding = Encoding.getByName(charset);
  if (encoding != null) return encoding;
  throw FormatException('Unsupported encoding "$charset"');
}

final RegExp _ASCII_ONLY = RegExp(r"^[\x00-\x7F]+$");

bool isPlainAscii(String string) => _ASCII_ONLY.hasMatch(string);

Uint8List toUint8List(List<int> input) {
  if (input is Uint8List) return input;
  if (input is TypedData) {
    // TODO(nweiz): remove "as" when issue 11080 is fixed.
    return Uint8List.view((input as TypedData).buffer);
  }
  return Uint8List.fromList(input);
}

ByteStream toByteStream(Stream<List<int>> stream) {
  if (stream is ByteStream) return stream;
  return ByteStream(stream);
}

Stream<T> onDone<T>(Stream<T> stream, void onDone()) => 
  stream.transform(StreamTransformer.fromHandlers(handleDone: (sink) {
    sink.close();
    onDone();
  }));

  Future store(Stream stream, EventSink sink) {
    var completer = Completer();
    stream.listen(sink.add,
      onError: sink.addError,
      onDone: () {
        sink.close();
        completer.complete();
      });
      return completer.future;
  }

  Future writeStreamToSink(Stream stream, EventSink sink) {
    var completer = Completer();
    stream.listen(sink.add,
      onError: sink.addError,
      onDone: () => completer.complete());
      return completer.future;
  }

  class Pair<E, F> {
    E first;
    F last;
    
    Pair(this.first, this.last);

    String toString() => '($first, $last)';

    bool operator==(other) {
      if (other is! Pair) return false;
      return other.first == first && other.last == last;
    }

    int get hashCode => first.hashCode ^ last.hashCode;
  }

  void chainToCompleter(Future future, Completer completer) {
    future.then(completer.complete, onError: completer.completeError);
  }