part of '../entity.dart';

class Chat extends Entity {
  int get id => get('id');
  String get type => get('type');
  String get title => get('title');
  User get user => type == 'private' ? get<User>('user') : null;
  
  ChatPhoto get photo => get<ChatPhoto>('photo');
  String get description => get('description');
  String get invite_link => get('invite_link');
  Message get pinned_message => get<Message>('pinned_message');
  
  ChatPermissions get permissions => get<ChatPermissions>('permissions');
  int get slow_mode_delay => get('slow_mode_delay');
  String get sticker_set_name => get('sticker_set_name');
  bool get can_set_sticker_set => get('can_set_sticker_set');

  Chat(Bot bot, Map<String, dynamic> data) : super(bot, data);

  Future<void> unpin() async {
    await _bot.request('unpinChatMessage', {'chat_id': id});
  }

  Future<void> pin(int message_id, {bool disable_notification = true}) async {
    await _bot.request('pinChatMessage', {
      'chat_id': id,
      'message_id': message_id,
      'disable_notification': disable_notification
    });
  }

  Future<void> leave() async {
    await _bot.request('leaveChat', {'chat_id': id});
  }

  Future<void> load() async {
    var chat = await _bot.request<Chat>('getChat', {'chat_id': id});

    set('title', chat.title);
    set('description', chat.description);
    set('invite_link', chat.invite_link);
    set('slow_mode_delay', chat.slow_mode_delay);
    set('sticker_set_name', chat.sticker_set_name);
    set('can_set_sticker_set', chat.can_set_sticker_set);

    set('photo', chat.get('photo'));
    set('pinned_message', chat.get('pinned_message'));
    set('permissions', chat.get('permissions'));
  }

  Future<ChatMember> getChatMember(int user_id) => _bot.request<ChatMember>(
      'getChatMember', {'chat_id': id, 'user_id': user_id});

  Future<List<ChatMember>> getAdministrators() =>
      _bot.requestMany<ChatMember>('getChatAdministrators', {'chat_id': id});

  Future<int> getMembersCount() =>
      _bot.request<int>('getChatMembersCount', {'chat_id': id});

  Future<void> setTitle(String title) async {
    await _bot.request('setChatTitle', {'chat_id': id, 'title': title});
    set('title', title);
  }

  Future<void> setDescription(String description) async {
    await _bot.request(
        'setChatDescription', {'chat_id': id, 'description': description});
    set('description', description);
  }

  Future<void> setPermissions(ChatPermissions permissions) => _bot.request(
      'setChatPermissions',
      {'chat_id': id, 'permissions': permissions.serialized});

  Future<void> setStickerSet(String set_name) => _bot.request(
      'setChatStickerSet', {'chat_id': id, 'sticker_set_name': set_name});

  Future<void> deleteSticketSet() =>
      _bot.request('deleteChatStickerSet', {'chat_id': id});

  Future<String> getInviteLink() =>
      _bot.request<String>('exportChatInviteLink', {'chat_id': id});

  Future<Message> sendMessage(String text,
      {String parse_mode,
      bool disable_notification = false,
      Keyboard reply_markup}) {
    var data = {
      'chat_id': id,
      'text': text,
      'parse_mode': parse_mode ?? _bot.parseMode,
      'disable_notification': disable_notification
    };

    if (reply_markup != null) data['reply_markup'] = reply_markup.serialized;
    
    return _bot.request<Message>('sendMessage', data);
  }
}
