import 'package:path/path.dart' as Path;
import 'package:phonedb/models/phoneModel.dart';
import 'package:sqflite/sqflite.dart';

class PhoneDatabase {
  static const dbVersion = 1;
  static const dbFileName = 'phone_database.db';
  static const phonesTableName = 'phones';
  static const idColumn = 'id';
  static const producerColumn = 'producer';
  static const modelColumn = 'model';
  static const softVersionColumn = 'softVersion';
  static const pictureColumn = 'picture';
  static const createDbSql = 'CREATE TABLE $phonesTableName'
      '($idColumn INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      '$producerColumn TEXT,'
      '$modelColumn TEXT,'
      '$softVersionColumn TEXT,'
      '$pictureColumn TEXT)';

  static Future<Database> openPhoneDatabase() async {
    return openDatabase(
      Path.join(await getDatabasesPath(), dbFileName),
      onCreate: (db, version) {
        return db.execute(createDbSql);
      },
      version: dbVersion, // wersje umożliwiają upgrade/downgrade bazy
    );
  }

  static Future<int> insertPhone(Phone phone) async {
    final phoneDatabase = await openPhoneDatabase();
    final newItemId = await phoneDatabase.insert(
      phonesTableName,
      phone.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return newItemId;
  }

  static Future<int> updatePhone (Phone phone) async {
    final phoneDatabase = await openPhoneDatabase();
    final updatedItem = await phoneDatabase.update(
      phonesTableName,
      phone.toJson(),
      where: '$idColumn = ?',
      whereArgs: [phone.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return updatedItem;
  }

  static Future<int> deletePhone(Phone phone) async {
    final phoneDatabase = await openPhoneDatabase();
    final deletedItem = await phoneDatabase.delete(
      phonesTableName,
      where: '$idColumn = ?',
      whereArgs: [phone.id],
    );
    return deletedItem;
  }

  static Future<List<Phone>> getPhones() async {
    final phoneDatabase = await openPhoneDatabase();
    final List<Map<String, dynamic>> phoneMapList =
    await phoneDatabase.query(phonesTableName); // konwertuje List<Map<String, dynamic> z bazy na List<Word>.

    if (phoneMapList.isNotEmpty) {
        return List.generate(phoneMapList.length, (index) => Phone.fromJson(phoneMapList[index]));
    }

    return [];
  }

}