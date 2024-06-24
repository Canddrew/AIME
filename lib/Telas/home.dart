import 'package:flutter/material.dart';
import 'package:aime/Telas/anonimo.dart';
import 'package:aime/Telas/login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6ECFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo ao AIME',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'Seu assistente de saúde pessoal',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Para continuar, clique em como deseja seguir no app:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                proxT(context, Login1("Info Home"));
              },
              child: Text('Login/Cadastro'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEFEFF4),
                foregroundColor: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                proxT(context, Anonimo1("Info Home"));
              },
              child: Text('Anônimo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEFEFF4),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void proxT(ctx, page) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }
}
  void proxT(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context)
    {
      return page;
    }
    ));
  }