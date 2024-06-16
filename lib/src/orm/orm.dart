import 'package:dartshine/src/orm/types.dart';

class Orm{
  String tableName;
  List<Map<String, dynamic>> fields;
  final StringBuffer createQuery = StringBuffer();

  Orm({required this.tableName, required this.fields}){
    createQuery.write('CREATE TABLE IF NOT EXISTS $tableName (');
  }

  void migrate(){
    for(Map<String, dynamic> field in fields){
      if(field['field_name'] is String){
        createQuery.write("${field['field_name']} ");
      }

      if(field['type'] is OrmTypes){
        createQuery.write("${ormTypeToString(field['type'])} ");
      }

      if(field['primary_key'] == true){
        createQuery.write('PRIMARY KEY ');
      }

      if(field['autoincrement'] == true){
        createQuery.write('AUTOINCREMENT ');
      }

      createQuery.write(',');
    }

    createQuery.write(');');
  }
}