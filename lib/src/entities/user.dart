part of '../entity.dart';

class User extends Entity {
  int id;
  bool is_bot;
  String first_name;
  String last_name;
  String username;

  Chat _chat;

  User(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    id = data['id'];
    is_bot = data['is_bot'];
    first_name = data['first_name'];
    last_name = data['last_name'];
    username = data['username'];
  }

  // For some reason, unbanning a non-banned user is the same as kicking them without banning
  Future<void> kick() => unban();

  Future<void> ban({int until_date = 0}) async {
    await _bot.request('kickChatMember',
        {'chat_id': _chat.id, 'user_id': id, 'until_date': until_date});
  }

  Future<void> unban() async {
    await _bot.request('unbanChatMember', {'chat_id': _chat.id, 'user_id': id});
  }

  Future<ChatPermissions> getPermissions() async {
    var member = await _bot.request<ChatMember>(
        'getChatMember', {'chat_id': _chat.id, 'user_id': id});

    return member.permissions;
  }

  Future<void> restrict(ChatPermissions permissions,
      {int until_date = 0}) async {
    await _bot.request('restrictChatMember', {
      'chat_id': _chat.id,
      'user_id': id,
      'permissions': permissions.serialized,
      'until_date': until_date
    });
  }

  Future<void> mute({int until_date = 0}) =>
      restrict(ChatPermissions(), until_date: until_date);

  Future<void> promote(
      {bool can_change_info = false,
      bool can_post_messages = false,
      bool can_edit_messages = false,
      bool can_delete_messages = false,
      bool can_invite_users = false,
      bool can_restrict_members = false,
      bool can_pin_messages = false,
      bool can_promote_members = false}) async {
    await _bot.request('promoteChatMember', {
      'chat_id': _chat.id,
      'user_id': id,
      'can_change_info': can_change_info,
      'can_post_messages': can_post_messages,
      'can_edit_messages': can_edit_messages,
      'can_delete_messages': can_delete_messages,
      'can_invite_users': can_invite_users,
      'can_restrict_members': can_restrict_members,
      'can_pin_messages': can_pin_messages,
      'can_promote_members': can_promote_members
    });
  }

  Future<void> setCustomTitle(String custom_title) async {
    await _bot.request('setChatAdministratorCustomTitle', {
      'chat_id': _chat.id,
      'user_id': id,
      'custom_title': custom_title
    });
  }
}
