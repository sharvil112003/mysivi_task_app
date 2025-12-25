import 'dart:convert';
import 'package:http/http.dart' as http;

class DictionaryApi {
  final http.Client _client;
  DictionaryApi(this._client);

  Future<List<String>> meanings(String word) async {
    final cleaned = word.trim().toLowerCase();
    if (cleaned.isEmpty) return [];

    final uri = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$cleaned');
    final res = await _client.get(uri);
    if (res.statusCode != 200) return [];

    final data = jsonDecode(res.body);
    if (data is! List || data.isEmpty) return [];

    final first = data.first;
    final meanings = <String>[];

    final meaningsArr = first['meanings'];
    if (meaningsArr is List) {
      for (final m in meaningsArr) {
        final defs = m['definitions'];
        if (defs is List) {
          for (final d in defs) {
            final def = d['definition'];
            if (def is String && def.trim().isNotEmpty) {
              meanings.add(def.trim());
              if (meanings.length >= 3) return meanings;
            }
          }
        }
      }
    }
    return meanings;
  }
}
