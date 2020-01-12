import 'dart:io' as io;
import '../../bot.dart';
import '../../entity.dart';

part 'file_type.dart';
part 'photo.dart';
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

  final Map<String, dynamic> _info = {};
  FileType _type;
  bool _local;
  final Bot _bot;

  File(this._bot, Map<String, dynamic> data) : super(_bot, data) {
    _local = false;
  }

  Future<void> download(String path) async {
    var file = await _bot.request<File>('getFile', {'file_id': file_id});

    await _bot.downloadFile(file.file_path, path);
  }

  static T load<T extends File>(Bot bot, String id, bool local) {
    final factories = <Type, Function>{
      Animation: (b) => Animation(b, {}),
      Audio: (b) => Audio(b, {}),
      Document: (b) => Document(b, {}),
      VideoNote: (b) => VideoNote(b, {}),
      Video: (b) => Video(b, {}),
      Voice: (b) => Voice(b, {}),
      Photo: (b) => Photo(b, {})
    };

    var e = factories[T](bot) as File;
    e._local = local;

    local ? e.set('file_path', id) : e.set('file_id', id);

    return e;
  }

  dynamic toFile() {
    return _local ? io.File(file_path) : file_id;
  }

  Future<Message> send(dynamic chat_id,
      {String caption,
      String parse_mode,
      bool disable_web_page_preview,
      bool disable_notification,
      int reply_to_message_id,
      Keyboard reply_markup}) {
    var data = {
      'chat_id': chat_id,
      'caption': caption ?? '',
      'parse_mode': parse_mode ?? _bot.parseMode,
      'disable_web_page_preview': disable_web_page_preview,
      'disable_notification': disable_notification,
      'reply_to_message_id': reply_to_message_id,
      'reply_markup': reply_markup
    };
    if (reply_markup == null) data.remove('reply_markup');
    data.addAll(_info);
    
    _type ??= FileType.Document;

    data[_type.parameter] = toFile();

    return _bot.request<Message>(_type.method, data);
  }
}
