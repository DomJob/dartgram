part of '../entity.dart';

class CallbackQuery extends Entity {
  String get id => get('id');
  User from;
  String get data => get('data');
  Message message;

  CallbackQuery(Bot _bot, Map<String, dynamic> raw) : super(_bot, raw) {
    from = Entity.generate<User>(_bot, raw['from']);
    message = Entity.generate<Message>(_bot, raw['message']);
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
