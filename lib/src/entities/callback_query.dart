part of '../entity.dart';

class CallbackQuery extends Entity {
  String id;
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

  Future<void> answer(
      {String text,
      bool show_alert = false,
      String url,
      int cache_time = 0}) async {

    var data = {'callback_query_id': id, 'cache_time': cache_time, 'show_alert': show_alert};

    if(text != null) data['text'] = text;
    if(url != null) data['url'] = url;

    await _bot.request('answerCallbackQuery', data);
  }
}
