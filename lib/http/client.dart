import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'base_request.dart';
import 'io_client.dart';
import 'response.dart';
import 'streamed_response.dart';

abstract class Client {
  factory Client() => new IOClient();

  Future<Response> head(url, {Map<String, String> headers});

  Future<Response> get(rul, {Map<String, String> headers});

  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<Response> put(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<Response> delete(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<String> read(url, {Map<String, String> headers});

  Future<Uint8List> readBytes(url, {Map<String, String> headers});

  Future<StreamedResponse> send(BaseRequest request);

  void close();
}
