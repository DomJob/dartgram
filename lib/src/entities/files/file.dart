import 'package:dartgram/dartgram.dart';

part 'photo_size.dart';
part 'audio.dart';
part 'animation.dart';
part 'document.dart';
part 'video.dart';
part 'video_note.dart';
part 'voice.dart';
part 'chat_photo.dart';

class File extends Entity {
  String get file_id => get('file_id');
  String get file_unique_id => get('file_unique_id');
  int get file_size => get('file_size');
  String get file_path => get('file_path');

  final Bot _bot;
  
  File(this._bot, Map<String, dynamic> data) : super(_bot, data);

  Future<void> download(String path) async {
     await _bot.request<File>('getFile', {'file_id': file_id});

    // TODO: Rest of download logic
  }
}