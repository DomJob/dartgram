part of 'file.dart';

class VideoNote extends File {
  int get length => get('length');
  set length(int l) => _info['length'] = l;

  int get duration => get('duration');
  set duration(int d) => _info['duration'] = d;
  
  Photo _thumb;
  Photo get thumb => _thumb;
  set thumb(Photo t) => _info['thumb'] = t?.toFile();

  VideoNote(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    _type = FileType.VideoNote;
    thumb = Entity.generate<Photo>(bot, data['thumb']);
  }
}