part of '../entity.dart';

class Chat extends Entity {
  int id;
  String type;
  User user;

  String title;
  String description;
  ChatPhoto photo;
  String invite_link;
  Message pinned_message;
  ChatPermissions permissions;
  int slow_mode_delay;
  String sticker_set_name;
  bool can_set_sticker_set;

  final Bot _bot;

  Chat(this._bot, Map<String, dynamic> data) : super(data) {
    id = data['id'];
    type = data['type'];

    if (type == 'private') {
      user = User(_bot, data);
    }

    title = data['title'];
    description = data['description'];
    photo = Entity.generate<ChatPhoto>(_bot, data['photo']);
    invite_link = data['invite_link'];
    pinned_message = Entity.generate<Message>(_bot, data['pinned_message']);
    permissions = Entity.generate<ChatPermissions>(_bot, data['permissions']);

    slow_mode_delay = data['slow_mode_delay'];
    sticker_set_name = data['sticker_set_name'];
    can_set_sticker_set = data['can_set_sticker_set'];
  }

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
    raw = chat.raw;

    title = chat.title;
    description = chat.description;
    photo = chat.photo;
    invite_link = chat.invite_link;
    pinned_message = chat.pinned_message;
    permissions = chat.permissions;
    slow_mode_delay = chat.slow_mode_delay;
    sticker_set_name = chat.sticker_set_name;
    can_set_sticker_set = chat.can_set_sticker_set;
  }

  Future<ChatMember> getChatMember(int user_id) => _bot.request<ChatMember>(
      'getChatMember', {'chat_id': id, 'user_id': user_id});

  Future<List<ChatMember>> getAdministrators() =>
      _bot.requestMany<ChatMember>('getChatAdministrators', {'chat_id': id});

  Future<int> getMembersCount() =>
      _bot.request<int>('getChatMembersCount', {'chat_id': id});

  Future<void> setTitle(String title) async {
    await _bot.request('setChatTitle', {'chat_id': id, 'title': title});
    raw['title'] = title;
  }

  Future<void> setDescription(String description) async {
    await _bot.request(
        'setChatDescription', {'chat_id': id, 'description': description});
    raw['description'] = description;
  }

  Future<void> setPermissions(ChatPermissions permissions) async {
    await _bot.request('setChatPermissions',
        {'chat_id': id, 'permissions': permissions.serialized});
  }
}
