part of '../entity.dart';

class Message extends Entity {
  int get id => get('message_id');
  int get date => get('date');
  String get text => get('text');
  String get forward_sender_name => get('forward_sender_name');

  Message get reply_to_message => cast<Message>('reply_to_message');
  Chat get chat => cast<Chat>('chat');

  User get from {
    var u = cast<User>('from');
    if (u != null) u._chat = chat;
    return u;
  }

  User get forward_from => cast<User>('forward_from');
  Sticker get sticker => cast<Sticker>('sticker');
  User get left_chat_member => cast<User>('left_chat_member');
  List<User> get new_chat_members => castMany<User>('new_chat_members');
  List<PhotoSize> get photo => castMany<PhotoSize>('photo');

  bool get is_forward => forward_from != null || forward_sender_name != null;

  bool get is_special => [
        'new_chat_members',
        'left_chat_member',
        'new_chat_title',
        'new_chat_photo',
        'delete_chat_photo',
        'pinned_message'
      ].any((String k) => get(k) != null);

  String get command => args != null ? args[0] : null;

  List<String> get args {
    if (text.isEmpty) return null;
    if (text[0] != '/' && text[0] != '!') return null;

    var args = text.split(' ');
    args[0] = args[0].replaceFirst(args[0][0], '');

    return args;
  }

  Message(Bot bot, Map<String, dynamic> data) : super(bot, data);

  Future<Message> reply(String text,
      {String parse_mode,
      bool disable_notification = false,
      Keyboard reply_markup}) {
    var data = {
      'chat_id': chat.id,
      'reply_to_message_id': id,
      'text': text,
      'parse_mode': parse_mode ?? _bot.parseMode,
      'disable_notification': disable_notification
    };

    print(data);

    if (reply_markup != null) data['reply_markup'] = reply_markup.serialized;
    return _bot.request<Message>('sendMessage', data);
  }

  Future<Message> forward(dynamic chat_id,
      {bool disable_notification = false}) {
    return _bot.request<Message>('forwardMessage', {
      'chat_id': chat_id,
      'from_chat_id': chat.id,
      'message_id': id,
      'disable_notification': disable_notification
    });
  }

  Future<Message> edit(String text,
      {String parse_mode, bool disable_notification = false}) {
    return _bot.request<Message>('editMessageText', {
      'chat_id': chat.id,
      'message_id': id,
      'text': text,
      'parse_mode': parse_mode ?? _bot.parseMode,
      'disable_notification': disable_notification
    });
  }

  Future<void> delete() async {
    await _bot.request('deleteMessage', {'chat_id': chat.id, 'message_id': id});
  }

  Future<void> pin({bool disable_notification = true}) =>
      chat.pin(id, disable_notification: disable_notification);
}
