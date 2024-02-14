import 'dart:io';

import 'package:bionic_interface/data_persistence/user_data_entity.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
part 'app_database.g.dart';

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'user.sqlite'));

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [UserDataEntity])
class AppDb extends _$AppDb{

  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

}