part of 'file.dart';

class Photo extends File {
  int get width => get('width');
  int get height => get('height');

  Photo(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    _type = FileType.Photo;
  }
}