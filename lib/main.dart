import 'package:flutter/material.dart';
import 'package:aime/watson_http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIME',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String response = '';

  @override
  void initState() {
    super.initState();
    sendMessageToAssistant();
  }

  Future<void> sendMessageToAssistant() async {
    final watsonAssistant = WatsonAssistant(
      '2rNTnxGFSxwIgqH5yTfYrr5z4n_mrXR4nMSK5OvwR66l',
      'https://api.us-south.assistant.watson.cloud.ibm.com',
      '20874089-62d4-43ee-bccc-00c87e144130',
    );

    try {
      final sessionId = await watsonAssistant.createSession();
      final assistantResponse = await watsonAssistant.sendMessage(sessionId, 'Hello');
      setState(() {
        response = assistantResponse.toString();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AIME'),
      ),
      body: Center(
        child: Text(
          'Response from AIME: $response',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


