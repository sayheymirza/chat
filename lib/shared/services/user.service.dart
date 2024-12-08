import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class UserService extends GetxService {
  // a user from database
  Future<Stream<List<ProfileModel>>> stream({required String userId}) async {
    try {
      log('[user.service.dart] selected user $userId');

      var query = database.select(database.userTable);

      query.where((row) => row.id.equals(userId.toString()));

      query.limit(1);

      query.orderBy([
        (row) => drift.OrderingTerm(
            expression: row.updated_at, mode: drift.OrderingMode.desc),
      ]);

      var result = query.watch().map(
            (value) => value
                .map(
                  (value) => ProfileModel.fromDatabase({
                    ...value.data,
                    'id': value.id,
                    'status': value.status,
                    'avatar': value.avatar,
                    'fullname': value.fullname,
                    'lastAt': value.last,
                    'seen': value.seen,
                    'verified': value.verified,
                  }),
                )
                .toList(),
          );

      return result;
    } catch (e) {
      return Stream.empty();
    }
  }

  Future<bool> fetch({required String userId}) async {
    try {
      var result = await ApiService.user.one(id: userId);

      if (result != null) {
        await save(profile: result);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> save({required ProfileModel profile}) async {
    try {
      log('[user.service.dart] saved user with id ${profile.id}');
      await database.into(database.userTable).insertOnConflictUpdate(
            UserTableCompanion.insert(
              id: profile.id!.toString(),
              status: profile.status!,
              avatar: profile.avatar!,
              fullname: profile.fullname!,
              last: profile.lastAt.toString(),
              seen: profile.seen!,
              data: profile.toJson(),
              verified: drift.Value(profile.verified ?? false),
            ),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete({required String userId}) async {
    try {
      log('[user.service.dart] deleted user with id $userId');
      await (database.delete(database.userTable)
            ..where((row) => row.id.equals(userId)))
          .go();
    } catch (e) {
      print(e);
    }
  }

  Future<void> clear() async {
    try {
      var count = await database.delete(database.userTable).go();

      log('[user.service.dart] clear $count users');
    } catch (e) {
      //
    }
  }
}
