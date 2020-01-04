part of '../entity.dart';

class ChatPermissions extends Entity {
  bool can_send_messages;
  bool can_send_media_messages;
  bool can_send_polls;
  bool can_send_other_messages;
  bool can_add_web_page_previews;
  bool can_change_info;
  bool can_invite_users;
  bool can_pin_messages;

  ChatPermissions(Map<String, dynamic> data) : super(data) {
    can_send_messages = data['can_send_messages'];
    can_send_media_messages = data['can_send_media_messages'];
    can_send_polls = data['can_send_polls'];
    can_send_other_messages = data['can_send_other_messages'];
    can_add_web_page_previews = data['can_add_web_page_previews'];
    can_change_info = data['can_change_info'];
    can_invite_users = data['can_invite_users'];
    can_pin_messages = data['can_pin_messages'];
  }
}
