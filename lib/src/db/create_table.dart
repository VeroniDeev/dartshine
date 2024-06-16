import 'package:sqlite3/sqlite3.dart';

enum DbType{
  sqlite,
  postgresql
}

class CreateTable{
  DbType dbType;
  Database? sqliteDb;
  Map<String, String> dbConfig;

  CreateTable({required this.dbType, required this.dbConfig}){
    if(dbType == DbType.sqlite){
      sqliteDb = sqlite3.open(dbConfig['filename']!);
    }
  }

  void create(List<String> tables){

  }

  void createSqlite(List<String> tables){
    for(String table in tables){
      sqliteDb?.execute(table);
    }
  }
}