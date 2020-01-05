part of 'file.dart';

class Document extends File {
  PhotoSize thumb;
  String get file_name => get('file_name');
  String get mime_type => get('mime_type');

  Document(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    thumb = Entity.generate<PhotoSize>(bot, data['thumb']);
  }
}