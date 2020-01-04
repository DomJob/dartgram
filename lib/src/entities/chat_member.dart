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
  bool can_change_info;
  bool can_invite_users;
  bool can_pin_messages;
  bool is_member;
  bool can_send_messages;
  bool can_send_media_messages;
  bool can_send_polls;
  bool can_send_other_messages;
  bool can_add_web_page_previews;

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
    can_change_info = data['can_change_info'];
    can_invite_users = data['can_invite_users'];
    can_pin_messages = data['can_pin_messages'];
    is_member = data['is_member'];
    can_send_messages = data['can_send_messages'];
    can_send_media_messages = data['can_send_media_messages'];
    can_send_polls = data['can_send_polls'];
    can_send_other_messages = data['can_send_other_messages'];
    can_add_web_page_previews = data['can_add_web_page_previews'];
  }
}
