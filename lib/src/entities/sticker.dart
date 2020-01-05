part of '../entity.dart';

class Sticker extends Entity {
  String id;
  String set_name;

  Sticker(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    id = data['file_id'];
    set_name = data['set_name'];
  }
}