import 'package:eventos/model/eventos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EventManagerApp());
}

class EventManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 0, 0, 0),
        appBarTheme: AppBarTheme(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      backgroundColor: Color.fromARGB(255, 209, 209, 209),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EventPage()),
                );
              },
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 20),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      backgroundColor: Color.fromARGB(255, 209, 209, 209),
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
                    SnackBar(
                      content: const Text('Senhas não coincidem'),
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
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dois ListTile por linha
          crossAxisSpacing: 10.0, // Espaço horizontal entre os itens
          mainAxisSpacing: 10.0, // Espaço vertical entre os itens
        ),
        padding: EdgeInsets.all(10.0),
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
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8.0), // Espaçamento opcional
                  Text('Horário: ${event['horario'] ?? ''}'),
                  Text('Data: ${event['data'] ?? ''}'),
                  const SizedBox(height: 8.0), // Espaçamento opcional
                  Text('Local: ${event['local'] ?? ''}'),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.delete),
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
        child: Icon(Icons.add),
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

class AddEventPage extends StatelessWidget {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Evento'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Nome do Evento'),
            ),
            TextField(
              controller: _eventDateController,
              decoration: const InputDecoration(labelText: 'Data'),
            ),
            TextField(
              controller: _eventTimeController,
              decoration: const InputDecoration(labelText: 'Horário'),
            ),
            TextField(
              controller: _eventLocationController,
              decoration: const InputDecoration(labelText: 'Local'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar a lógica para salvar o evento.
                // Por exemplo, você pode adicionar o evento à lista de eventos e retornar à página anterior.

                Navigator.pop(context);
              },
              child: const Text('Salvar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}