import 'package:eventos/db/db.dart';
import 'package:eventos/model/eventos.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future<int> insertEvent(Event event) async {
  Database db = await getDatabase();
  debugPrint("ENTREI");
  return db.insert('eventos', event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Map<String, dynamic>>> findall() async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados = await db.query('eventos');
  return dados;
}

Future<int> deleteById(int id) async {
  debugPrint("Deletando o ID: $id");
  Database db = await getDatabase();
  return db.delete('eventos', where: "id = ?", whereArgs: [id]);
}

Future<int> updateEvent(Event event) async {
  Database db = await getDatabase();
  return db.update(
    'eventos',
    event.toMap(),
    where: "id = ?",
    whereArgs: [event.id],
  );
}
// Future<int> deleteById(int id) async {
//   debugPrint("Deletando o ID: $id");
//   Database db = await getDatabase();
//   return db.delete('eventos', where: "id = ?", whereArgs: [id]);
// }
