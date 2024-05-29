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
    try {
      final String message = 'estou doente';
      final String assistantResponse = await WatsonHttp.sendMessage(message);
      setState(() {
        response = assistantResponse;
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
          'Resposta da AIME: $response',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}