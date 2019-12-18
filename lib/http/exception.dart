
class ClientException implements Exception {
  
  final String message;

  final Uri uri;

  ClientException(this.message, [this.uri]);

  String toString() => message;
}