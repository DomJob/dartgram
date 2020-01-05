part of 'file.dart';

class VideoNote extends File {
  int get length => get('length');
  int get duration => get('duration');
  PhotoSize thumb;

  VideoNote(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    thumb = Entity.generate<PhotoSize>(bot, data['thumb']);
  }
}