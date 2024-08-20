import 'package:eventos/db/db.dart';
import 'package:eventos/model/eventos.dart';
import 'package:sqflite/sqflite.dart';

Future<int> insertEvent(Event event) async {
  Database db = await getDatabase();
  return db.insert('eventos', event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Map<String, dynamic>>> findall() async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados = await db.query('eventos');
  return dados;
}
