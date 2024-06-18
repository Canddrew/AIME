import 'package:flutter/material.dart';
import 'package:aime/watson_http.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> messages = [];
  final TextEditingController messageController = TextEditingController();
  late WatsonAssistant watsonAssistant;
  late String sessionId;

  @override
  void initState() {
    super.initState();
    initWatsonAssistant();
  }

  Future<void> initWatsonAssistant() async {
    watsonAssistant = WatsonAssistant(
      '2rNTnxGFSxwIgqH5yTfYrr5z4n_mrXR4nMSK5OvwR66l',
      'https://api.us-south.assistant.watson.cloud.ibm.com',
      '20874089-62d4-43ee-bccc-00c87e144130',
    );

    try {
      sessionId = await watsonAssistant.createSession();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;
    setState(() {
      messages.add('You: $message');
    });
    messageController.clear();

    try {
      final response = await watsonAssistant.sendMessage(sessionId, message);
      setState(() {
        messages.add('AIME: ${response['output']['generic'][0]['text']}');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text('AIME'),

        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    messages[index],
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escreva sua mensagem para a AIME...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendMessage(messageController.text),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}