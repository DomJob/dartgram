part of '../entity.dart';

class Message extends Entity {
  int get id => get('message_id');
  User get from {
    var u = get<User>('from');
    if (u != null) u._chat = chat;
    return u;
  }

  int get date => get('date');
  Chat get chat => get<Chat>('chat');

  User get forward_from => get<User>('forward_from');
  Chat get forward_from_chat => get<Chat>('forward_from_chat');
  String get forward_sigature => get('forward_signature');
  String get forward_sender_name => get('forward_sender_name');
  int get foward_date => get('forward_date');

  Message get reply_to_message => get<Message>('reply_to_message');
  int get edit_date => get('edit_date');

  String get media_group_id => get('media_group_id');
  String get author_signature => get('author_signature');

  String get text => get('text');

  List<MessageEntity> get entities => getMany<MessageEntity>('entities');
  List<MessageEntity> get caption_entities => getMany<MessageEntity>('caption_entities');

  Audio get audio => get<Audio>('audio');
  Document get document => get<Document>('document');
  Animation get animation => get<Animation>('animation');
  List<Photo> get photo => getMany<Photo>('photo');
  Sticker get sticker => get<Sticker>('sticker');
  Video get video => get<Video>('video');
  Voice get voice => get<Voice>('voice');
  VideoNote get video_note => get<VideoNote>('video_note');
  String get caption => get('caption');
  // TODO: Contact, Location, Venue, Poll

  List<User> get new_chat_members => getMany<User>('new_chat_members');
  User get left_chat_member => get<User>('left_chat_member');

  String get new_chat_title => get('new_chat_title');

  bool get is_forward => forward_from != null || forward_sender_name != null;

  bool get is_special => [
        'new_chat_members',
        'left_chat_member',
        'new_chat_title',
        'new_chat_photo',
        'delete_chat_photo',
        'pinned_message',
        'supergroup_chat_created',
        'migrate_to_chat_id',
        'migrate_from_chat_id'
      ].any((String k) => get(k) != null);

  String get command => args != null ? args[0] : null;

  List<String> get args {
    if (text?.isEmpty ?? true) return null;
    if (!_bot.commandCharacters.contains(text[0])) return null;

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
