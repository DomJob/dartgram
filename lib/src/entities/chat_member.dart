part of '../entity.dart';

class ChatMember extends Entity {
  User user;
  String get status => get('status');
  String get custom_title => get('custom_title');
  int get until_date => get('until_date');
  bool get can_be_edited => get('can_be_edited');
  bool get can_post_messages => get('can_post_messages');
  bool get can_edit_messages => get('can_edit_messages');
  bool get can_delete_messages => get('can_delete_messages');
  bool get can_restrict_members => get('can_restrict_members');
  bool get can_promote_members => get('can_promote_members');
  bool get is_member => get('is_member');

  ChatPermissions permissions;

  ChatMember(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    user = Entity.generate<User>(bot, data['user']);
    permissions = Entity.generate<ChatPermissions>(bot, data);
  }
}
