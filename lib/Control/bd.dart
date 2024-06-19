import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class BD {
  BD._();
  static final BD instancia = BD._();
  static Database? _bancoDados;
  static const String tabelaNome = 'usuarios';
  static const String Id = 'id';
  static const String Email = 'email';
  static const String Senha = 'senha';

  Future<Database> get bancoDados async {
    if (_bancoDados != null) return _bancoDados!;

    _bancoDados = await _inicializarBancoDados();
    return _bancoDados!;
  }

  Future<Database> _inicializarBancoDados() async {
    String caminho = join(await getDatabasesPath(), 'aime.db');
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _criarTabela,
    );
  }

  Future<void> _criarTabela(Database db, int versao) async {
    await db.execute('''
    CREATE TABLE $tabelaNome (
          $Id INTEGER PRIMARY KEY AUTOINCREMENT,
          $Email TEXT NOT NULL UNIQUE,
          $Senha TEXT NOT NULL
    )
    ''');
  }

  Future<int> inserirUsuario(String email, String senha) async {
    Database db = await BD.instancia.bancoDados;
    String senhaCriptografada = _criptografarSenha(senha);
    return await db.insert(tabelaNome, {
      Email: email.toLowerCase(),
      Senha: senhaCriptografada,
    });
  }

  Future<Map<String, dynamic>?> autenticarUsuario(String email, String senha) async {
    Database db = await BD.instancia.bancoDados;
    String senhaCriptografada = _criptografarSenha(senha);
    List<Map<String, dynamic>> resultado = await db.query(
      tabelaNome,
      where: '$Email = ? AND $Senha = ?',
      whereArgs: [email.toLowerCase(), senhaCriptografada],
    );
    if (resultado.isNotEmpty) {
      return resultado.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> obterUsuarioPorEmail(String email) async {
    Database db = await BD.instancia.bancoDados;
    List<Map<String, dynamic>> resultado = await db.query(
      tabelaNome,
      where: '$Email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (resultado.isNotEmpty) {
      return resultado.first;
    } else {
      return null;
    }
  }

  String _criptografarSenha(String senha) {
    var bytes = utf8.encode(senha);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
