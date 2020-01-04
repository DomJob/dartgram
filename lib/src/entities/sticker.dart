part of '../entity.dart';

class Sticker extends Entity {
  String id;
  String set_name;

  Sticker(Map<String, dynamic> data) : super(data) {
    id = data['file_id'];
    set_name = data['set_name'];
  }
}