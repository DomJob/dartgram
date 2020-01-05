part of '../entity.dart';

class ChatPermissions extends Entity {
  bool get can_send_messages => get('can_send_messages') ?? false;
  bool get can_send_media_messages => get('can_send_media_messages') ?? false;
  bool get can_send_polls => get('can_send_polls') ?? false;
  bool get can_send_other_messages => get('can_send_other_messages') ?? false;
  bool get can_add_web_page_previews => get('can_add_web_page_previews') ?? false;
  bool get can_change_info => get('can_change_info') ?? false;
  bool get can_invite_users => get('can_invite_users') ?? false;
  bool get can_pin_messages => get('can_pin_messages') ?? false;

  ChatPermissions._load(Map<String, dynamic> data) : super(data);

  ChatPermissions(
      {bool can_send_messages = false,
      bool can_send_media_messages = false,
      bool can_send_polls = false,
      bool can_send_other_messages = false,
      bool can_add_web_page_previews = false,
      bool can_change_info = false,
      bool can_invite_users = false,
      bool can_pin_messages = false})
      : super({}) {
    set('can_send_messages', can_send_messages);
    set('can_send_media_messages', can_send_media_messages);
    set('can_send_polls', can_send_polls);
    set('can_send_other_messages', can_send_other_messages);
    set('can_add_web_page_previews', can_add_web_page_previews);
    set('can_change_info', can_change_info);
    set('can_invite_users', can_invite_users);
    set('can_pin_messages', can_pin_messages);
  }
}
