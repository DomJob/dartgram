part of 'file.dart';

class ChatPhoto extends File {
  String get small_file_id => get('small_file_id');
  String get small_file_unique_id => get('small_file_unique_id');
  String get big_file_id => get('big_file_id');
  String get big_file_unique_id => get('big_file_unique_id');

  ChatPhoto(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    set('file_id', big_file_id);
    set('file_unique_id', big_file_unique_id);
  }
}