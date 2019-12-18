import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'client.dart';
import 'response.dart';

Future<Response> head(url, {Map<String, String> headers}) =>
    _withClient((client) => client.head(url, headers: headers));

Future<Response> get(url, {Map<String, String> headers}) => 
    _withClient((client) => client.get(url, headers: headers));

Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) => 
    _withClient((client) => client.post(url, headers: headers, body: body, encoding:  encoding));

Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) =>
    _withClient((client) => client.put(url, headers: headers, body: body, encoding: encoding));

Future<Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) => 
    _withClient((client) => client.patch(url, headers: headers, body: body, encoding: encoding));

Future<Response> delete(url, {Map<String, String> headers, body, Encoding encoding} ) =>
    _withClient((client) => client.delete(url, headers: headers, body: body, encoding:  encoding));

Future<String> read(url, {Map<String, String> headers}) =>
    _withClient((client) => client.read(url, headers: headers));

Future<Uint8List> readBytes(url, {Map<String, String> headers}) =>
    _withClient((client) => client.readBytes(url, headers: headers));

Future<T> _withClient<T>(Future<T> fn(Client client)) async {
  var client = Client();
  try {
    return await fn(client);
  } finally {
    client.close();
  }
}