part of '../entity.dart';

class CallbackQuery extends Entity {
  int id;
  User from;
  Message message;
  String data;

  final Bot _bot;

  CallbackQuery(this._bot, Map<String, dynamic> raw) : super(raw) {
    id = raw['id'];
    from = Entity.generate<User>(_bot, raw['from']);
    message = Entity.generate<Message>(_bot, raw['message']);
    data = raw['data'];
  }

  Future<void> answer({String text,
          bool show_alert = false,
          String url,
          int cache_time = 0}) =>
      _bot.request('answerCallbackQuery', {
        'callback_query_id': id,
        'text': text,
        'show_alert': show_alert,
        'url': url,
        'cache_time': cache_time
      });
}
