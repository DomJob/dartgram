part of 'file.dart';

class Video extends File {
  int get width => get('width');
  int get height => get('height');
  int get duration => get('duration');
  PhotoSize thumb;
  String get mime_type => get('mime_type');

  Video(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    thumb = Entity.generate<PhotoSize>(bot, data['thumb']);
  }
}