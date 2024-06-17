import 'package:dartshine/src/orm/db_type.dart';
import 'package:dartshine/src/orm/types.dart';
import 'package:sqlite3/sqlite3.dart';

class Orm{
  String tableName;
  List<Map<String, dynamic>> fields;
  DbType? dbType;
  Database? sqliteDb;

  Orm({required this.tableName, required this.fields, DbType? databaseType, this.sqliteDb}){
    if(databaseType != null){
      dbType = databaseType;
    }else{
      dbType = DbType.sqlite;
    }
  }

  void createTable() {
    if(dbType == DbType.sqlite){
        createSqliteTable();
    }
  }

  void createSqliteTable() {
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

    sqliteDb?.execute(createQuery.toString());
  }
}