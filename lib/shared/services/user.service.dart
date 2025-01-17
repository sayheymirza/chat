import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class UserService extends GetxService {
  // a user from database
  Future<ProfileModel?> one({required String userId}) async {
    try {
      var query = database.select(database.userTable);

      query.where((row) => row.id.equals(userId.toString()));

      query.limit(1);

      var result = await query.getSingle();

      if (result != null) {
        return ProfileModel.fromDatabase({
          ...result.data,
          'id': result.id,
          'status': result.status,
          'avatar': result.avatar,
          'fullname': result.fullname,
          'lastAt': result.last,
          'seen': result.seen,
          'verified': result.verified,
        });
      }

      return null;
    } catch (e) {
      return null;
    }
  }

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

  Future<void> relation({
    required String userId,
    required RELATION_ACTION action,
  }) async {
    await database.transaction(() async {
      var user = await (database.select(database.userTable)
            ..where((row) => row.id.equals(userId)))
          .getSingle();

      if (user != null) {
        if (action == RELATION_ACTION.BLOCK) {
          user.data['relation']['blocked'] = true;
        }

        if (action == RELATION_ACTION.UNBLOCK) {
          user.data['relation']['blocked'] = false;
        }

        // favorite
        if (action == RELATION_ACTION.FAVORITE) {
          user.data['relation']['favorited'] = true;
        }

        // unfavorite
        if (action == RELATION_ACTION.DISFAVORITE) {
          user.data['relation']['favorited'] = false;
        }

        // update
        await (database.update(database.userTable)
              ..where((row) => row.id.equals(userId)))
            .write(
          UserTableCompanion(
            data: drift.Value(user.data),
          ),
        );
      }
    });
  }

  Future<void> see({required String userId}) async {
    var seened = await seen(userId: userId);

    if (seened > 0) {
      return;
    }

    var time = int.parse(
        Services.configs.get(key: CONSTANTS.STORAGE_EYE_TIME).toString());
    var now = DateTime.now();

    // add time (hours) to now
    var end_at = now.add(Duration(hours: time));

    Services.configs.set(
      key: 'user:$userId',
      value: {'end_at': end_at.toString(), 'start_at': now.toString()},
    );

    log('[user.service.dart] user $userId seen for $time hours');
  }

  double seen({required String userId}) {
    var now = DateTime.now();
    var expire_at = Services.configs.get(key: 'user:$userId');

    if (expire_at == null) {
      return 0;
    }

    var start_at = DateTime.parse(expire_at['start_at']);
    var end_at = DateTime.parse(expire_at['end_at']);

    if (now.isAfter(end_at)) {
      Services.configs.unset(key: 'user:$userId');

      return 0;
    }

    //   how much percent of time has passed in hours
    var percent = (100 * now.microsecondsSinceEpoch) /
        end_at.microsecondsSinceEpoch;

    return percent / 100;
  }
}
