import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitoterapica/model/plant_model.dart';

class PlantDatabase {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'plants.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE plants(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            sciName TEXT,
            uses TEXT,
            contraindications TEXT,
            waysOfUse TEXT,
            imagePath TEXT
          )
          ''',
        );
      },
      version: 3,
    );
  }

  Future<void> createPlant(Plant plant) async {
    await _database.insert('plants', plant.toMap());
  }

  Future<List<Plant>> getPlants() async {
    final List<Map<String, dynamic>> maps = await _database.query('plants');
    return List.generate(maps.length, (i) {
      return Plant(
        id: maps[i]['id'],
        name: maps[i]['name'],
        sciName: maps[i]['sciName'],
        uses: maps[i]['uses'],
        contraindications: maps[i]['contraindications'],
        waysOfUse: maps[i]['waysOfUse'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  Future<void> updatePlant(Plant plant) async {
    await _database.update(
      'plants',
      plant.toMap(),
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }

  Future<void> deletePlant(int id) async {
    await _database.delete('plants', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearPlants() async {
    await _database.delete('plants');
  }
}
