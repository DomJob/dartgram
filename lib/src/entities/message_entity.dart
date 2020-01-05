part of '../entity.dart';

class MessageEntity extends Entity {
  String get type => get('type');
  int get offset => get('offset');
  int get length => get('length');
  String get url => get('url');
  User get user => get<User>('user');

  MessageEntity(Bot bot, Map<String, dynamic> data) : super(bot, data);
}