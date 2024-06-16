class Orm{
  String tableName;
  List<Map<String, dynamic>> fields;

  Orm({required this.tableName, required this.fields});

  void migrate(){}
}