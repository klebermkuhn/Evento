import 'package:eventos/dao/eventDao.dart';
import 'package:eventos/model/eventos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar a data e o horário

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _convidados = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Método para exibir o date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Método para exibir o time picker
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Converte a data e horário selecionados em um DateTime
  DateTime? _getCombinedDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      return DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }
    return null;
  }

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
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDate(context),
                    child: Text(_selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Selecionar Data'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickTime(context),
                    child: Text(_selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Selecionar Horário'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _eventLocationController,
              decoration: const InputDecoration(labelText: 'Local'),
            ),
            TextField(
              controller: _convidados,
              decoration: const InputDecoration(labelText: 'convidados:'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                DateTime? dateTime = _getCombinedDateTime();
                if (dateTime != null) {
                  // Aqui você pode adicionar a lógica para salvar o evento com a data e hora combinadas.
                  // Exemplo: salvar no banco de dados ou na lista de eventos.
                  // Você pode usar o método de inserção no DAO como `insertEvent(Event(nome: ..., dataHora: dateTime, ...))`
                  insertEvent(Event(
                      nome: _eventNameController.text,
                      dataHora: dateTime,
                      local: _eventLocationController.text,
                      convidados: _convidados.text));
                  Navigator.pop(context);
                } else {
                  // Exibe uma mensagem de erro se a data ou horário não foram selecionados
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, selecione a data e o horário.'),
                    ),
                  );
                }
              },
              child: const Text('Salvar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}
