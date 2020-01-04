part of '../entity.dart';

class Chat extends Entity {
  int id;
  String type;
  User from;

  Chat(Bot bot, Map<String, dynamic> data) : super(data) {
    id = data['id'];
    type = data['type'];

    if(type == 'private') {
      from = User(bot, data);
    }
  }
}