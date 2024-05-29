import 'dart:convert';
import 'package:http/http.dart' as http;

class WatsonHttp {
  static Future<String> sendMessage(String message) async {
    final String apiKey = '2rNTnxGFSxwIgqH5yTfYrr5z4n_mrXR4nMSK5OvwR66l';
    final String url = 'https://api.us-south.assistant.watson.cloud.ibm.com/instances/edfa2fd5-9441-43a9-9f24-0f3db90546d9';
    final String assistantId = 'e212261d-2815-4f08-b34d-789cee8fd2e6';

    final String endpoint = '$url/v1/workspaces/$assistantId/message?version=2021-08-01';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'input': {'text': message}}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['output']['generic'][0]['text'];
    } else {
      throw Exception('Failed to send message to assistant');
    }
  }
}
