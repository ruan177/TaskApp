import 'dart:async';

import 'package:drift/drift.dart';
import '../database.dart';
import '../models/user.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [User])
abstract class UserDao extends DatabaseAccessor<MyDatabase> with _$UserDaoMixin {
  UserDao(MyDatabase db) : super(db);


  Future<int> addUser(User user) => into(db.user).insert(user as Insertable<UserData>);

  Future<List> getAllUsers() => select(db.user).get();

  Future<UserData?> getUserById(int id) {
    return (select(db.user)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<UserData?> findUserByEmail(String email) async {
    return (select(db.user)..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  Future<bool> updateUser(User user) => update(db.user).replace(user as Insertable<UserData>);

  Future<int> deleteUser(int id) {
    return (delete(db.user)..where((u) => u.id.equals(id))).go();
  }
}
