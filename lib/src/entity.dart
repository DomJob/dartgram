import 'dart:convert';

import 'package:dartgram/dartgram.dart';

part 'entities/chat.dart';
part 'entities/user.dart';
part 'entities/message.dart';
part 'entities/sticker.dart';
part 'entities/update.dart';
part 'entities/callback_query.dart';
part 'entities/chat_photo.dart';
part 'entities/chat_permissions.dart';

class Entity {
  Map<String, dynamic> raw;

  Entity(this.raw);

  @override
  String toString() {
    return '[${runtimeType}] ' + JsonEncoder.withIndent(' ').convert(raw);
  }

  String serialize() => json.encode(raw);

  static T generate<T extends Entity>(Bot bot, dynamic data) {
    if(data == null) return null;

    final factories = <Type, Function>{
      Chat: (b, r) => Chat(b, r),
      User: (b, r) => User(b, r),
      Message: (b, r) => Message(b, r),
      Update: (b, r) => Update(b, r),
      Sticker: (b, r) => Sticker(r),
      CallbackQuery: (b, r) => CallbackQuery(b, r),
      ChatPhoto: (b, r) => ChatPhoto(b, r),
      ChatPermissions: (b, r) => ChatPermissions(r)
    };

    if (!factories.containsKey(T)) return null;

    return factories[T](bot, data);
  }

  static List<T> generateMany<T extends Entity>(Bot bot, List data) {
    if(data == null) return null;

    return data.map((d) => generate<T>(bot, d)).toList();
  }
}
