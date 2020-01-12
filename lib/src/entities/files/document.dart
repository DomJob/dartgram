part of 'file.dart';

class Document extends File {
  String get file_name => get('file_name');
  String get mime_type => get('mime_type');

  Photo _thumb;
  Photo get thumb => _thumb;
  set thumb(Photo t) => _info['thumb'] = t.toFile();

  Document(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    _type = FileType.Document;
    thumb = Entity.generate<Photo>(bot, data['thumb']);
  }
}