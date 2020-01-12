part of 'file.dart';

class Audio extends File {
  int get duration => get('duration');
  set duration(int d) => _info['duration'] = d;

  String get performer => get('performer');
  set performer(String p) => _info['performer'] = p;

  String get title => get('title');
  set title(String t) => _info['title'] = t;

  String get mime_type => get('mime_type');
  
  Photo _thumb;
  Photo get thumb => _thumb;
  set thumb(Photo t) => _info['thumb'] = t.toFile();

  Audio(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    _type = FileType.Audio;
    thumb = Entity.generate<Photo>(bot, data['thumb']);
  }
}