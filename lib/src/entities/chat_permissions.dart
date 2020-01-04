part of '../entity.dart';

class ChatPermissions extends Entity {
  bool get can_send_messages => raw['can_send_messages'] ?? false;
  bool get can_send_media_messages => raw['can_send_media_messages'] ?? false;
  bool get can_send_polls => raw['can_send_polls'] ?? false;
  bool get can_send_other_messages => raw['can_send_other_messages'] ?? false;
  bool get can_add_web_page_previews => raw['can_add_web_page_previews'] ?? false;
  bool get can_change_info => raw['can_change_info'] ?? false;
  bool get can_invite_users => raw['can_invite_users'] ?? false;
  bool get can_pin_messages => raw['can_pin_messages'] ?? false;

  ChatPermissions._load(Map<String, dynamic> data) : super(data);

  ChatPermissions() : super({});

  static ChatPermissions get messages => ChatPermissions._load({'can_send_messages' : true});
  static ChatPermissions get media => ChatPermissions._load({'can_send_media_messages' : true});
  static ChatPermissions get polls => ChatPermissions._load({'can_send_polls' : true});
  static ChatPermissions get others => ChatPermissions._load({'can_send_other_messages' : true});
  static ChatPermissions get previews => ChatPermissions._load({'can_add_web_page_previews' : true});
  static ChatPermissions get info => ChatPermissions._load({'can_change_info' : true});
  static ChatPermissions get invite => ChatPermissions._load({'can_invite_users' : true});
  static ChatPermissions get pin => ChatPermissions._load({'can_pin_messages' : true});

  ChatPermissions operator &(ChatPermissions other) {
    raw.addAll(other.raw);

    return this;
  }
}
