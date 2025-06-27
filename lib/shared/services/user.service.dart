import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/apis/socket.model.dart';
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

      query.where((row) => row.id.equals(userId));

      query.limit(1);

      var result = await query.getSingleOrNull();

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
      print(e);
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

      var query = database.select(database.userTable);

      query.where((row) => row.id.equals(profile.id.toString()));

      query.limit(1);

      var result = await query.getSingleOrNull();

      if (result != null) {
        await (database.update(database.userTable)
              ..where((e) => e.id.equals(profile.id.toString())))
            .write(
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
      } else {
        await database.into(database.userTable).insert(
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
      }

      // await database.into(database.userTable).insertOnConflictUpdate(
      //       UserTableCompanion.insert(
      //         id: profile.id!.toString(),
      //         status: profile.status!,
      //         avatar: profile.avatar!,
      //         fullname: profile.fullname!,
      //         last: profile.lastAt.toString(),
      //         seen: profile.seen!,
      //         data: profile.toJson(),
      //         verified: drift.Value(profile.verified ?? false),
      //       ),
      //     );
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
          .getSingleOrNull();

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

        // like
        if (action == RELATION_ACTION.LIKE) {
          if (user.data['relation']['disliked'] == true) {
            user.data['relationCount']['dislikes'] =
                user.data['relationCount']['dislikes'] - 1;
          }

          user.data['relation']['liked'] = true;
          user.data['relation']['disliked'] = false;

          user.data['relationCount']['likes'] =
              user.data['relationCount']['likes'] + 1;
        }

        // dislike
        if (action == RELATION_ACTION.DISLIKE) {
          if (user.data['relation']['liked'] == true) {
            user.data['relationCount']['likes'] =
                user.data['relationCount']['likes'] - 1;
          }

          user.data['relation']['liked'] = false;
          user.data['relation']['disliked'] = true;

          user.data['relationCount']['dislikes'] =
              user.data['relationCount']['dislikes'] + 1;
        }

        // update
        await (database.update(database.userTable)
              ..where((row) => row.id.equals(userId)))
            .write(
          UserTableCompanion(
            data: drift.Value(user.data),
          ),
        );

        log('[user.service.dart] user $userId relation $action');
      }
    });
  }

  Future<void> see({required String userId}) async {
    var seened = seen(userId: userId);

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

    var end_at = DateTime.parse(expire_at['end_at']);

    if (now.isAfter(end_at)) {
      Services.configs.unset(key: 'user:$userId');

      return 0;
    }

    //   how much percent of time has passed in hours
    var percent =
        (100 * now.microsecondsSinceEpoch) / end_at.microsecondsSinceEpoch;

    return percent / 100;
  }

  void like({required String userId}) {
    ApiService.socket.send(
      event: SOCKET_EVENTS.SOCKET_REQUEST,
      data: {
        'action': 'frontend.do_interaction',
        'body': {'entity_id': userId, 'type': 'like'},
      },
    );
  }

  void dislike({required String userId}) {
    ApiService.socket.send(
      event: SOCKET_EVENTS.SOCKET_REQUEST,
      data: {
        'action': 'frontend.do_interaction',
        'body': {'entity_id': userId, 'type': 'dislike'},
      },
    );
  }

  void statuses({required List<String> userIds}) {
    if (userIds.isNotEmpty) {
      ApiService.socket.send(
        event: SOCKET_EVENTS.SOCKET_REQUEST,
        data: {
          'action': 'frontend.get_onlines_status',
          'body': {
            'ids': userIds
                .where((id) => id != null && id.trim().isNotEmpty)
                .map(int.parse)
                .toList()
          },
        },
      );
    }
  }

  Future<void> changeStatus({
    required String userId,
    required String status,
  }) async {
    var update = database.update(database.userTable);

    update.where((row) => row.id.equals(userId.toString()));

    var output = await update.writeReturning(
      UserTableCompanion(
        seen: drift.Value(status),
      ),
    );

    if (output.isNotEmpty) {
      log('[user.service.dart] changed status ${output.first.id} to ${output.first.seen}');
    }
  }

  Future<void> saveFromSearch({required ProfileSearchModel profile}) async {
    try {
      await database.transaction(() async {
        try {
          // get one by id
          var user = await (database.select(database.userTable)
                ..where((row) => row.id.equals(profile.id.toString())))
              .getSingleOrNull();

          if (user == null) {
            // create user
            await database.into(database.userTable).insert(
                  UserTableCompanion.insert(
                    id: profile.id!.toString(),
                    status: 'unknown',
                    avatar: profile.avatar!,
                    fullname: profile.fullname!,
                    last: DateTime.now().toString(),
                    seen: profile.seen!,
                    data: profile.toJson(),
                    verified: drift.Value(profile.verified ?? false),
                  ),
                );

            log('[user.service.dart] create user ${profile.id} from search as seen ${profile.seen}');
          } else {
            // update user
            await (database.update(database.userTable)
                  ..where((row) => row.id.equals(profile.id.toString())))
                .writeReturning(
              UserTableCompanion(
                avatar: drift.Value(profile.avatar!),
                fullname: drift.Value(profile.fullname!),
                seen: drift.Value(profile.seen!),
              ),
            );

            log('[user.service.dart] update user ${profile.id} from search as seen ${profile.seen}');
          }
        } catch (e) {
          //
        }
      });
    } catch (e) {
      //
    }
  }
}
