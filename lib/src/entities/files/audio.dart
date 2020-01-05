part of 'file.dart';

class Audio extends File {
  int get duration => get('duration');
  String get performer => get('performer');
  String get title => get('title');
  String get mime_type => get('mime_type');
  PhotoSize thumb;

  Audio(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    thumb = Entity.generate<PhotoSize>(bot, data['thumb']);
  }
}