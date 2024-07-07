import 'package:dartshine/dartshine.dart';

Orm user = Orm(tableName: 'user', fields: [
  {
    'field_name': 'id',
    'primary_key': true,
    'type': OrmTypes.int,
  },
  {
    'field_name': 'username',
    'type': OrmTypes.string,
  },
  {
    'field_name': 'name',
    'type': OrmTypes.string,
  },
]);