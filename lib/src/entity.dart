import 'dart:convert';

import 'package:dartgram/dartgram.dart';
import 'entities/files/file.dart';

part 'entities/chat.dart';
part 'entities/user.dart';
part 'entities/user_profile_photos.dart';
part 'entities/message.dart';
part 'entities/message_entity.dart';
part 'entities/sticker.dart';
part 'entities/update.dart';
part 'entities/callback_query.dart';
part 'entities/chat_permissions.dart';
part 'entities/chat_member.dart';
part 'entities/keyboard.dart';

class Entity {
  final Map<String, dynamic> _raw;

  void set(String k, dynamic v) => _raw[k] = v;

  T get<T>(String k) => generate<T>(_bot, _raw[k]);
  List<T> getMany<T>(String k) => generateMany<T>(_bot, _raw[k]);

  final Bot _bot;

  Entity(this._bot, this._raw);

  @override
  String toString() {
    return '[${runtimeType}] ' + JsonEncoder.withIndent(' ').convert(_raw);
  }

  String get serialized => json.encode(_raw);

  static T generate<T>(Bot bot, dynamic data) {
    final factories = <Type, Function>{
      Chat: (b, r) => Chat(b, r),
      User: (b, r) => User(b, r),
      Message: (b, r) => Message(b, r),
      MessageEntity: (b, r) => MessageEntity(b, r),
      Update: (b, r) => Update(b, r),
      Sticker: (b, r) => Sticker(b, r),
      CallbackQuery: (b, r) => CallbackQuery(b, r),
      ChatPermissions: (b, r) => ChatPermissions._load(b, r),
      ChatMember: (b, r) => ChatMember(b, r),
      
      File: (b, r) => File(b, r),
      ChatPhoto: (b, r) => ChatPhoto(b, r),
      Animation: (b, r) => Animation(b, r),
      Audio: (b, r) => Audio(b, r),
      Document: (b, r) => Document(b, r),
      Photo: (b, r) => Photo(b, r),
      VideoNote: (b, r) => VideoNote(b, r),
      Video: (b, r) => Video(b, r),
      Voice: (b, r) => Voice(b, r),

      UserProfilePhotos: (b, r) => UserProfilePhotos(b, r)
    };

    if(data == null) return null;
    if (!factories.containsKey(T)) return data;

    return factories[T](bot, data);
  }

  static List<T> generateMany<T>(Bot bot, List data) {
    if(data == null) return null;

    return data.map((d) => generate<T>(bot, d)).toList();
  }
}
