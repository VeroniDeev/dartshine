import 'package:dartshine/src/orm/orm.dart';
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

  void create(List<Orm> ormList) {
    if(dbType == DbType.sqlite){
      for(Orm orm in ormList){
        String query = createSqlite(orm);
        sqliteDb?.execute(query);
      }
    }
  }

  String createSqlite(Orm orm) {
    StringBuffer createQuery = StringBuffer();

    createQuery.write('CREATE TABLE IF NOT EXISTS ${orm.tableName} (');

    for (int i = 0; i < orm.fields.length; i++) {
      Map<String, dynamic> field = orm.fields[i];

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

      if(i != orm.fields.length-1){
        createQuery.write(',');
      }
    }

    createQuery.write(');');

    return createQuery.toString();
  }
}
