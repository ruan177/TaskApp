import 'dart:async';

import 'package:drift/drift.dart';
import '../../UI/screens/register.dart';
import '../database.dart';
import '../models/user.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [User])
class UserDao extends DatabaseAccessor<MyDatabase> with _$UserDaoMixin {
  UserDao(MyDatabase db) : super(db);


  Future<int> addUser(IUser user) => into(db.user).insert(UserCompanion(
    name: Value(user.name),
    email: Value(user.email),
    password: Value(user.password),
  ));

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
