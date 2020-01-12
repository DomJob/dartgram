part of 'file.dart';

enum FileType { Animation, Audio, Document, Photo, Video, VideoNote, Voice }

extension _FTConverter on FileType {
  String get method {
    switch (this) {
      case FileType.Animation:
        return 'sendAnimation';
      case FileType.Audio:
        return 'sendAudio';
      case FileType.Document:
        return 'sendDocument';
      case FileType.Photo:
        return 'sendPhoto';
      case FileType.Video:
        return 'sendVideo';
      case FileType.VideoNote:
        return 'sendVideoNote';
      case FileType.Voice:
        return 'sendVoice';
    }
    return null;
  }

  String get parameter {
    switch (this) {
      case FileType.Animation:
        return 'animation';
      case FileType.Audio:
        return 'audio';
      case FileType.Document:
        return 'document';
      case FileType.Photo:
        return 'photo';
      case FileType.Video:
        return 'video';
      case FileType.VideoNote:
        return 'video_note';
      case FileType.Voice:
        return 'voice';
    }
    return null;
  }
}
