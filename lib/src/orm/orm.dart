import 'package:dartshine/src/orm/db_type.dart';
import 'package:dartshine/src/orm/types.dart';
import 'package:sqlite3/sqlite3.dart';

class Orm {
  String tableName;
  List<Map<String, dynamic>> fields;
  DbType? dbType;
  Database? sqliteDb;

  Orm(
      {required this.tableName,
      required this.fields,
      DbType? databaseType,
      this.sqliteDb}) {
    if (databaseType != null) {
      dbType = databaseType;
    } else {
      dbType = DbType.sqlite;
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

      if (i < fields.length - 1) {
        createQuery.write(',');
      }
    }

    createQuery.write(');');

    sqliteDb?.execute(createQuery.toString());
  }

  void insert({required Map<String, dynamic> datas}) {
    StringBuffer columnInsertQuery = StringBuffer();
    StringBuffer valueInsertQuery = StringBuffer();

    columnInsertQuery.write('INSERT INTO $tableName (');
    valueInsertQuery.write('VALUES (');

    List<MapEntry<String, dynamic>> dataToList = datas.entries.toList();

    for (int i = 0; i < datas.length; i++) {
      MapEntry<String, dynamic> data = dataToList[i];

      columnInsertQuery.write(data.key);

      if (data.value is String) {
        valueInsertQuery.write("'${data.value}'");
      } else if (data.value is int) {
        valueInsertQuery.write(data.value.toString());
      }

      if (i < datas.length - 1) {
        columnInsertQuery.write(',');
        valueInsertQuery.write(',');
      }
    }

    String result =
        '${columnInsertQuery.toString()}) ${valueInsertQuery.toString()});';

    if (dbType == DbType.sqlite) {
      sqliteDb?.execute(result);
    }
  }

  List<Map<String, dynamic>> get({required Map<String, dynamic> conditions}) {
    StringBuffer selectQuery = StringBuffer();
    selectQuery.write('SELECT ');

    if (conditions.containsKey('column') && conditions['column'] is List<String>) {
      List<String> selectorArray = conditions['column'];

      for (int i = 0; i < selectorArray.length; i++) {
        selectQuery.write(selectorArray[i]);

        if (i < selectorArray.length - 1) {
          selectQuery.write(", ");
        }
      }
    } else {
      selectQuery.write('*');
    }

    selectQuery.write(" FROM $tableName");

    List<Map<String, dynamic>> result = [];

    if (dbType == DbType.sqlite) {
      final ResultSet rows = sqliteDb!.select(selectQuery.toString());

      for (final Row row in rows) {
        for (String key in rows.columnNames) {
          result.add({key: row[key]});
        }
      }
    }

    return result;
  }
}


class DartshineOrm{
  List<Orm> orms = [];
  DbType type = DbType.sqlite;
  String name = '';

  void fillOrm(){
    if(type == DbType.sqlite){
      Database sqliteDb = sqlite3.open(name);

      for(Orm orm in orms){
        orm.dbType = type;
        orm.sqliteDb = sqliteDb;
        orm.createSqliteTable();
      }
    }
  }
}