import 'package:flutter/material.dart';
import 'package:aime/Telas/chat.dart';
import '../Control/bd.dart';

class Login1 extends StatelessWidget {
  final String parametro;

  const Login1(this.parametro);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldContainer(
                hintText: 'CPF/SUS/Email',
                controller: emailController,
              ),
              SizedBox(height: 20),
              TextFieldContainer(
                hintText: 'Senha',
                isPassword: true,
                controller: passwordController,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String email = emailController.text.toLowerCase();
                        String password = passwordController.text;
                        if (await _authenticateUser(context, email, password)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Chat()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Usuário não cadastrado ou credenciais inválidas')),
                          );
                        }
                      },
                      child: Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String email = emailController.text.toLowerCase();
                        String password = passwordController.text;
                        if (await _registerUser(context, email, password)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Usuário registrado com sucesso')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Falha ao registrar usuário')),
                          );
                        }
                      },
                      child: Text('Cadastrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              const Text(
                'Entrar com:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _authenticateUser(BuildContext context, String email, String password) async {
    BD bd = BD.instancia;
    var user = await bd.autenticarUsuario(email, password);
    return user != null;
  }

  Future<bool> _registerUser(BuildContext context, String email, String password) async {
    BD bd = BD.instancia;

    var existe = await bd.obterUsuarioPorEmail(email);
    if (existe != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Já existe uma conta registrada com este email')),
      );
      return false;
    }

    try {
      await bd.inserirUsuario(email, password);
      return true;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return false;
    }
  }
}

class TextFieldContainer extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const TextFieldContainer({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
