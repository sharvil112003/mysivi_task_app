import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ReceiverApi {
  final http.Client _client;
  ReceiverApi(this._client);

  Future<String> fetchRandomReceiverMessage() async {
    final uri = Uri.parse('https://dummyjson.com/comments?limit=10');
    final res = await _client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Receiver API failed: ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final comments = (json['comments'] as List).cast<Map<String, dynamic>>();
    if (comments.isEmpty) return 'Okay.';

    final pick = comments[Random().nextInt(comments.length)];
    final body = (pick['body'] as String?)?.trim() ?? '';
    return body.isEmpty ? 'Okay.' : body;
  }
}
