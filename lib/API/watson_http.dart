import 'package:http/http.dart' as http;
import 'dart:convert';

class WatsonAssistant {
  final String apiKey;
  final String url;
  final String assistantId;
  final String version = '2021-06-14';

  WatsonAssistant(this.apiKey, this.url, this.assistantId);

  Future<String> criarSessao() async {
    final String endpoint = '$url/v2/assistants/$assistantId/sessions?version=$version';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('apikey:$apiKey')),
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body)['session_id'];
    } else {
      throw Exception('Failed to create session: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> enviarMensagem(String sessionId, String message) async {
    final String endpoint = '$url/v2/assistants/$assistantId/sessions/$sessionId/message?version=$version';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('apikey:$apiKey')),
      },
      body: jsonEncode({'input': {'message_type': 'text', 'text': message}}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send message to Watson Assistant: ${response.statusCode}');
    }
  }
}




