part of 'file.dart';

class Video extends File {
  int get width => get('width');
  set width(int w) => _info['width'] = w;
  int get height => get('height');
  set height(int h) => _info['height'] = h;

  int get duration => get('duration');
  set duration(int d) => _info['duration'] = d;

  String get mime_type => get('mime_type');
  
  Photo _thumb;
  Photo get thumb => _thumb;
  set thumb(Photo t) => _info['thumb'] = t.toFile();

  Video(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    _type = FileType.VideoNote;
    thumb = Entity.generate<Photo>(bot, data['thumb']);
  }
}