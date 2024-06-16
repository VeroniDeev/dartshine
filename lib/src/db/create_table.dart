import 'package:dartshine/src/orm/types.dart';
import 'package:sqlite3/sqlite3.dart';

enum DbType { sqlite, postgresql }

class CreateTable {
  DbType dbType;
  Database? sqliteDb;
  Map<String, String> dbConfig;

  CreateTable({required this.dbType, required this.dbConfig}) {
    if (dbType == DbType.sqlite) {
      sqliteDb = sqlite3.open(dbConfig['filename']!);
    }
  }

  void create(List<List<Map<String, dynamic>>> fieldsList, String tableName) {
    if(dbType == DbType.sqlite){
      for(List<Map<String, dynamic>> fields in fieldsList){
        String query = createSqlite(fields, tableName);
        sqliteDb?.execute(query);
      }
    }
  }

  String createSqlite(List<Map<String, dynamic>> fields, String tableName) {
    StringBuffer createQuery = StringBuffer();

    createQuery.write('CREATE TABLE IF NOT EXISTS $tableName (');

    for (int i = 0; i < fields.length; i++) {
      Map<String, dynamic> field = fields[i];

      if (field['field_name'] is String) {
        createQuery.write("${field['field_name']} ");
      }

      if (field['type'] is OrmTypes) {
        createQuery.write("${ormTypeToString(field['type'])} ");
      }

      if (field['primary_key'] == true) {
        createQuery.write('PRIMARY KEY ');
      }

      if (field['autoincrement'] == true) {
        createQuery.write('AUTOINCREMENT ');
      }

      if(i != fields.length-1){
        createQuery.write(',');
      }
    }

    createQuery.write(');');

    return createQuery.toString();
  }
}
