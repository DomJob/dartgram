part of 'file.dart';

class Voice extends File {
  int get duration => get('duration');
  set duration(int d) => _info['duration'] = d;
  String get mime_type => get('mime_type');

  Voice(Bot bot, Map<String, dynamic> data) : super(bot, data) {
    _type = FileType.Voice;
  }
}
