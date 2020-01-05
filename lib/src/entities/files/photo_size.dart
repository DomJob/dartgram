part of 'file.dart';

class PhotoSize extends File {
  int get width => get('width');
  int get height => get('height');

  PhotoSize(Bot bot, Map<String, dynamic> data) : super(bot, data);
}