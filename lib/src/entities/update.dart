part of '../entity.dart';

enum UpdateType { message, edited, channel, edited_channel, callback }

class Update extends Entity {
  int id;
  UpdateType type;
  Message message;
  CallbackQuery callback_query;

  Update(Bot bot, Map<String, dynamic> data) : super(data) {
    id = data['update_id'];

    callback_query = Entity.generate<CallbackQuery>(bot, data['callback_query']);

    if (callback_query != null) {
      type = UpdateType.callback;
      return;
    }

    String key;
    if (data.containsKey('message')) {
      type = UpdateType.message;
      key = 'message';
    } else if (data.containsKey('edited_message')) {
      type = UpdateType.edited;
      key = 'edited_message';
    } else if (data.containsKey('channel_post')) {
      type = UpdateType.channel;
      key = 'channel_post';
    } else {
      type = UpdateType.edited_channel;
      key = 'edited_channel_post';
    }

    message = Entity.generate<Message>(bot, data[key]);
  }
}
