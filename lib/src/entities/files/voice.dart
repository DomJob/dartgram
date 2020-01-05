part of 'file.dart';

class Voice extends File {
  int get duration => get('duration');
  String get mime_type => get('mime_type');

  Voice(Bot bot, Map<String, dynamic> data) : super(bot, data);
}