import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user_local_storage/secure_storage.dart';

class BaseRepository {
  final http.Client _client;
  final SecureLocalStorage _storage;

  BaseRepository(this._client, this._storage);

  Future<http.Response> get(String url) async {
    final token = await _storage.retrieveToken();
    print(token);
    return _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
    final token = await _storage.retrieveToken();
    print(token);
    return _client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: body != null ? json.encode(body) : null,
    );
  }
}
