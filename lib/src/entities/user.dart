part of '../entity.dart';

class User extends Entity {
  int id;
  bool is_bot;
  String first_name;
  String last_name;
  String username;

  Chat _chat;

  final Bot _bot;

  User(this._bot, Map<String, dynamic> data) : super(data) {
    id = data['id'];
    is_bot = data['is_bot'];
    first_name = data['first_name'];
    last_name = data['last_name'];
    username = data['username'];
  }

  // For some reason, unbanning a non-banned user is the same as kicking them without banning
  Future<void> kick() => unban();

  Future<void> ban({int until_date = 0}) async {
    await _bot.request('kickChatMember', {
      'chat_id': _chat.id,
      'user_id': id,
      'until_date': until_date
    });
  }

  Future<void> unban() async {
    await _bot.request('unbanChatMember', {
      'chat_id': _chat.id,
      'user_id': id
    });
  }

  Future<ChatPermissions> getPermissions() async {
    var member = await _bot.request<ChatMember>('getChatMember', {
      'chat_id': _chat.id,
      'user_id': id});

    return member.permissions;
  }

  Future<void> restrict(ChatPermissions permissions, {int until_date = 0}) async {
    await _bot.request('restrictChatMember', {
      'chat_id': _chat.id,
      'user_id': id,
      'permissions': permissions.serialized,
      'until_date': until_date
    });
  }

  Future<void> mute({int until_date = 0}) => restrict(ChatPermissions(), until_date: until_date);
}
