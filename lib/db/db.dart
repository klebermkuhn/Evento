import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  String caminhoBanco = join(await getDatabasesPath(), 'dbE.db');

  return openDatabase(
    caminhoBanco,
    version: 1,
    onCreate: (db, version) {
      db.execute('''CREATE TABLE eventos(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nome TEXT, 
          datahora TEXT,
          local TEXT, 
        )
        ''');
    },
  );
}
