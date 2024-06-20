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
      enviarMensagemInicial(); // Envia a mensagem inicial assim que a sessão é criada
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
      backgroundColor: Color(0xFF80EAEA),
      appBar: AppBar(
        title: const Text('AIME'),
        backgroundColor: Color(0xFF80D7EA),
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: mensagens.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: mensagens[index].startsWith('Você') ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: mensagens[index].startsWith('Você') ? Colors.yellow : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        mensagens[index],
                        style: TextStyle(color: mensagens[index].startsWith('Você') ? Colors.black : Colors.black87),
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
            child: Row(
              children: [
                Expanded(
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
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => enviarMensagem(controladorMensagem.text),
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

