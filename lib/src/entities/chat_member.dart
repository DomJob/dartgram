part of '../entity.dart';

class ChatMember extends Entity {
  User user;
  String status;
  String custom_title;
  int until_date;
  bool can_be_edited;
  bool can_post_messages;
  bool can_edit_messages;
  bool can_delete_messages;
  bool can_restrict_members;
  bool can_promote_members;

  bool is_member;

  ChatPermissions permissions;

  ChatMember(Bot bot, Map<String, dynamic> data) : super(data) {
    user = Entity.generate<User>(bot, data['user']);

    status = data['status'];
    custom_title = data['custom_title'];
    until_date = data['until_date'];
    can_be_edited = data['can_be_edited'];
    can_post_messages = data['can_post_messages'];
    can_edit_messages = data['can_edit_messages'];
    can_delete_messages = data['can_delete_messages'];
    can_restrict_members = data['can_restrict_members'];
    can_promote_members = data['can_promote_members'];
    is_member = data['is_member'];
    permissions = Entity.generate<ChatPermissions>(bot, data);
  }
}
