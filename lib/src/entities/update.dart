part of '../entity.dart';

class Update extends Entity {
  int get id => get('update_id');
  UpdateType get type {
    var map = {
      'message': UpdateType.message,
      'edited_message': UpdateType.edited,
      'channel_post': UpdateType.channel,
      'edited_channel_post': UpdateType.edited_channel,
      'inline_query': UpdateType.inline,
      'chosen_inline_result': UpdateType.chosen_inline,
      'callback_query': UpdateType.callback
    };

    var key = map.keys.firstWhere((k) => get(k) != null);

    return map[key];
  }

  Message get message =>
      cast<Message>('message') ??
      cast<Message>('edited_message') ??
      cast<Message>('channel_post') ??
      cast<Message>('edited_channel_post');
  CallbackQuery get callback_query => cast<CallbackQuery>('callback_query');

  Update(Bot bot, Map<String, dynamic> data) : super(bot, data);
}

enum UpdateType {
  message,
  edited,
  channel,
  edited_channel,
  callback,
  // TODO: Handle these types of updates:
  inline,
  chosen_inline,
  poll
}
