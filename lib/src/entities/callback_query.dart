part of '../entity.dart';

class CallbackQuery extends Entity {
  int id;
  User from;
  Message message;
  String data;

  CallbackQuery(Bot bot, Map<String, dynamic> raw) : super(raw) {
    id = raw['id'];
    from = User(bot, raw['from']);
    message = raw.containsKey('message') ? Message(bot, raw['message']) : null;
    data = raw['data'];
  }
}
