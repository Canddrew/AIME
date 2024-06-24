import 'package:flutter/material.dart';
import 'package:aime/API/watson_http.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<String> mensagens = [];
  final TextEditingController controladorMensagem = TextEditingController();
  late WatsonAssistant assistenteWatson;
  late String sessionId;

  @override
  void initState() {
    super.initState();
    inicializarWatsonAssistant();
  }

  Future<void> inicializarWatsonAssistant() async {
    assistenteWatson = WatsonAssistant(
      '2rNTnxGFSxwIgqH5yTfYrr5z4n_mrXR4nMSK5OvwR66l',
      'https://api.us-south.assistant.watson.cloud.ibm.com',
      '20874089-62d4-43ee-bccc-00c87e144130',
    );

    try {
      sessionId = await assistenteWatson.criarSessao();
      enviarMensagemInicial();
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> enviarMensagemInicial() async {
    try {
      final resposta = await assistenteWatson.enviarMensagem(sessionId, '');
      setState(() {
        mensagens.insert(0, 'AIME: ${resposta['output']['generic'][0]['text']}');
      });
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> enviarMensagem(String mensagem) async {
    if (mensagem.isEmpty) return;
    setState(() {
      mensagens.insert(0, 'Você: $mensagem');
    });
    controladorMensagem.clear();

    try {
      final resposta = await assistenteWatson.enviarMensagem(sessionId, mensagem);
      setState(() {
        mensagens.insert(0, 'AIME: ${resposta['output']['generic'][0]['text']}');
      });
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6ECFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF6ECFFF),
        foregroundColor: Colors.black87,
        title: const Text(
          'AIME',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: mensagens.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Align(
                      alignment: mensagens[index].startsWith('Você')
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: mensagens[index].startsWith('Você')
                              ? Colors.white
                              : Color(0xFF4BA3E0),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(mensagens[index].startsWith('Você') ? 20 : 0),
                            topRight: Radius.circular(mensagens[index].startsWith('Você') ? 0 : 20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          mensagens[index],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF80EAEA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: controladorMensagem,
                        onSubmitted: (mensagem) => enviarMensagem(mensagem),
                        decoration: const InputDecoration(
                          hintText: 'Escreva sua mensagem para a AIME...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => enviarMensagem(controladorMensagem.text),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
