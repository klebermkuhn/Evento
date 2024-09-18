import 'dart:io';

// ignore: unused_import
import 'package:eventos/dao/eventDao.dart';
import 'package:eventos/model/eventos.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'add_event_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  debugPrint((await findall()).toString());
  runApp(const EventManagerApp());
}

findall() {}

class EventManagerApp extends StatelessWidget {
  const EventManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      backgroundColor: const Color.fromARGB(255, 209, 209, 209),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinha o conteúdo na parte inferior
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 30), // Espaço adicional entre campos e botão
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EventPage()),
                );
              },
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 40), // Espaço entre o botão e o texto
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: const Text(
                'Criar conta',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            const SizedBox(
                height: 60), // Espaço opcional na parte inferior da tela
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      backgroundColor: const Color.fromARGB(255, 209, 209, 209),
      body: Padding(
        padding: const EdgeInsets.all(250.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text ==
                    _confirmPasswordController.text) {
                  // Aqui você pode adicionar a lógica para criar a conta.
                  // Por exemplo, salvar o usuário em um banco de dados ou serviço.
                  Navigator.pop(context); // Retorna à página de login
                } else {
                  // Exibe um erro se as senhas não coincidirem.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Senhas não coincidem'),
                    ),
                  );
                }
              },
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class EventPage extends StatelessWidget {
  final List<Map<String, dynamic>> events = [
    Event(nome: 'kleber', dataHora: DateTime.now(), local: 'casa do lerner')
        .toMap(),
    Event(nome: 'kauan', dataHora: DateTime.now(), local: 'casa do kleber')
        .toMap(),
    // Adicione mais eventos aqui
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text('Event Manager'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dois ListTile por linha
          crossAxisSpacing: 10.0, // Espaço horizontal entre os itens
          mainAxisSpacing: 10.0, // Espaço vertical entre os itens
        ),
        padding: const EdgeInsets.all(10.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(
                  8.0), // Adicione algum padding se desejar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['nome'] ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8.0), // Espaçamento opcional
                  Text('Horário: ${event['horario'] ?? ''}'),
                  Text('Data: ${event['data'] ?? ''}'),
                  const SizedBox(height: 8.0), // Espaçamento opcional
                  Text('Local: ${event['local'] ?? ''}'),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Implementar funcionalidade de exclusão aqui, se necessário
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventPage()),
          );
        },
      ),
    );
  }
}
