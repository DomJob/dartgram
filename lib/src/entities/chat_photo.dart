part of '../entity.dart';

class ChatPhoto extends Entity {
  String small_file_id;
  String small_file_unique_id;
  String big_file_id;
  String big_file_unique_id;

  final Bot _bot;

  ChatPhoto(this._bot, Map<String, dynamic> data) : super(data) {
    small_file_id = data['small_file_id'];
    small_file_unique_id = data['small_file_unique_id'];
    big_file_id = data['big_file_id'];
    big_file_unique_id = data['big_file_unique_id'];
  }

  // TODO Download image
}