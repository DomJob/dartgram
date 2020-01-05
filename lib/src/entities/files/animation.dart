part of 'file.dart';

class Animation extends File {
  int get width => get('width');
  int get height => get('height');
  int get duration => get('duration');
  PhotoSize thumb;
  String get file_name => get('file_name');
  String get mime_type => get('mime_type');

  Animation(Bot bot, Map<String, dynamic> data) : super(bot, data){
    thumb = Entity.generate<PhotoSize>(bot, data['thumb']);
  }
}
