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


    //TODO: change these to look for username and password combos
    // basically make everything run on username
    // also endure that i have a function to check if a username exists


    Future<UserDataEntityData?> getUser(String userName) async{
      return await (select(userDataEntity)..where((tbl) => tbl.userName.equals(userName))).getSingle();
    }

    Future<bool> updateUserData(UserDataEntityCompanion entity) async {
      return await update(userDataEntity).replace(entity);
    }

    Future<int> insertNewUserData(UserDataEntityCompanion entity) async{
      """Returns the index of the new entity value""";
      return await into(userDataEntity).insert(entity);
    }

    Future<int> deleteUserData(int id) async{
      return await (delete(userDataEntity)..where((tbl) => tbl.id.equals(id))).go();
    }
}