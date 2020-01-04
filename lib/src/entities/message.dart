part of '../entity.dart';

class Message extends Entity {
  int id;
  User from;
  int date;
  Chat chat;
  String text;
  User forward_from;
  String forward_sender_name;
  Message reply_to_message;
  Sticker sticker;
  List<User> new_chat_members;
  User left_chat_member;
  bool is_special;

  String get command => args != null ? args[0] : null;

  List<String> get args {
    if(text.isEmpty) return null;
    if(text[0] != '/' && text[0] != '!') return null;

    var args = text.split(' ');
    args[0] = args[0].replaceFirst(args[0][0], '');

    return args;
  }

  final Bot _bot;

  Message(this._bot, Map<String, dynamic> data) : super(data) {
    id = data['message_id'];
    from = data.containsKey('from') ? User(_bot, data['from']) : null;
    date = data['date'];
    chat = Chat(_bot, data['chat']);
    text = data['text'] ?? '';

    forward_from = data.containsKey('forward_from')
        ? User(_bot, data['forward_from'])
        : null;
    forward_sender_name = data['forward_sender_name'];

    reply_to_message = data.containsKey('reply_to_message')
        ? Message(_bot, data['reply_to_message'])
        : null;

    sticker =
        data.containsKey('sticker') ? Sticker(data['sticker']) : null;

    if (data.containsKey('new_chat_members')) {
      List<dynamic> new_members = data['new_chat_members'];
      new_chat_members =
          new_members.map((dynamic userdata) => User(_bot, userdata)).toList();
    }

    left_chat_member = data.containsKey('left_chat_member')
        ? User(_bot, data['left_chat_member'])
        : null;

    is_special = [
      'new_chat_members',
      'left_chat_member',
      'new_chat_title',
      'new_chat_photo',
      'delete_chat_photo',
      'pinned_message'
    ].any((String k) => data.containsKey(k));
  }

  Future<Message> reply(String text, {String parse_mode, bool disable_notification=false}) async {
    print(text);

    var data = await _bot.request('sendMessage', {
      'chat_id': chat.id,
      'reply_to_message_id': id,
      'text': text,
      'parse_mode': parse_mode ?? _bot.parse_mode,
      'disable_notification': disable_notification
    });

    return data;
  }
}
