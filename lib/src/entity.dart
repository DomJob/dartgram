import 'package:dartgram/dartgram.dart';

part 'entities/chat.dart';
part 'entities/user.dart';
part 'entities/message.dart';
part 'entities/sticker.dart';
part 'entities/update.dart';
part 'entities/callback_query.dart';

class Entity {
  Map<String, dynamic> raw;

  Entity(this.raw);
  
  static T generate<T extends Entity>(Bot bot, Map<String, dynamic> raw) {
    final factories = <Type, Function>{
      Chat: (b,r) => Chat(b,r),
      User: (b,r) => User(b,r),
      Message: (b,r) => Message(b,r),
      Update: (b,r) => Update(b,r),
      Sticker: (b,r) => Sticker(r),
      CallbackQuery: (b,r) => CallbackQuery(b,r)
    };

    return factories[T](bot, raw);
  }
}