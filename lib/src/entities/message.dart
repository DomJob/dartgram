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
  List<PhotoSize> photo;

  bool is_forward;
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
    from = Entity.generate<User>(_bot, data['from']);
    date = data['date'];
    chat = Entity.generate<Chat>(_bot, data['chat']);
    text = data['text'] ?? '';

    if(from != null) from._chat = chat;

    forward_from = Entity.generate<User>(_bot, data['forward_from']);
    forward_sender_name = data['forward_sender_name'];

    reply_to_message = Entity.generate<Message>(_bot, data['reply_to_message']);

    sticker = Entity.generate<Sticker>(_bot, data['sticker']);

    new_chat_members = Entity.generateMany<User>(_bot, data['new_chat_members']);;
    left_chat_member = Entity.generate<User>(_bot, data['left_chat_member']);
    
    photo = Entity.generateMany<PhotoSize>(_bot, data['photo']);

    is_forward = forward_from != null || forward_sender_name != null;

    is_special = [
      'new_chat_members',
      'left_chat_member',
      'new_chat_title',
      'new_chat_photo',
      'delete_chat_photo',
      'pinned_message'
    ].any((String k) => data.containsKey(k));
  }

  Future<Message> reply(String text, {String parse_mode, bool disable_notification=false, Keyboard reply_markup}) {
    return _bot.request<Message>('sendMessage', {
      'chat_id': chat.id,
      'reply_to_message_id': id,
      'text': text,
      'parse_mode': parse_mode ?? _bot.parseMode,
      'disable_notification': disable_notification,
      'reply_markup': reply_markup?.serialized
    });
  }

  Future<Message> forward(dynamic chat_id, {bool disable_notification=false}) {
    return _bot.request<Message>('forwardMessage', {
      'chat_id': chat_id,
      'from_chat_id': chat.id,
      'message_id': id,
      'disable_notification': disable_notification
    });
  }

  Future<Message> edit(String text, {String parse_mode, bool disable_notification=false}) {
    return _bot.request<Message>('editMessageText', {
      'chat_id': chat.id,
      'message_id': id,
      'text': text,
      'parse_mode': parse_mode ?? _bot.parseMode,
      'disable_notification': disable_notification
    });
  }

  Future<void> delete() async {
    await _bot.request('deleteMessage', {
      'chat_id': chat.id,
      'message_id': id
    });
  }

  Future<void> pin({bool disable_notification = true}) => chat.pin(id, disable_notification: disable_notification);
}
