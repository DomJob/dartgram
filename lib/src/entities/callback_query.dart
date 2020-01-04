part of '../entity.dart';

class CallbackQuery extends Entity {
  int id;
  User from;
  Message message;
  String data;

  CallbackQuery(Bot bot, Map<String, dynamic> raw) : super(raw) {
    id = raw['id'];
    from = Entity.generate<User>(bot, raw['from']);
    message = Entity.generate<Message>(bot, raw['message']);
    data = raw['data'];
  }
}
