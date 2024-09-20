import 'dart:io';

import 'package:eventos/dao/eventDao.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'add_event_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  debugPrint("Banco: ");
  debugPrint((await findall()).toString());
  runApp(const EventManagerApp());
}

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
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEWEVENT'),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                style: TextStyle(color: Color.fromARGB(255, 71, 10, 10)),
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
        title: const Text('NEWEVENT'),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
//  final List<Map<String, dynamic>> events = [
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text('NEWEVENT'),
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
      body: FutureBuilder(
        future: findall(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                child: Text('Houve um erro de conexão com o banco de dados'),
              );
            case ConnectionState.waiting:
            // fez a requisição e estou esperando a resposta
            case ConnectionState.active:
              // active mostra que a conexão com o banco foi bem sucedida
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.done:
              List<Map> events = snapshot.data as List<Map>;
              return GridView.builder(
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
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        title: Text(
                          event['nome'] ?? '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        subtitle: Column(
                          children: [
                            const SizedBox(height: 5.0),
                            Text('Data: ${event['datahora'] ?? ''}'),
                            const SizedBox(height: 5.0),
                            Text('Local: ${event['local'] ?? ''}'),
                            Text('convidados: ${event['convidados'] ?? ''}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            // Chama a função de exclusão
                            await deleteById(event['id']);

                            // Atualiza a interface após a exclusão
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventPage()),
          ).then((value) {
            setState(() {});
          });
          ;
        },
      ),
    );
  }
}
