part of '../entity.dart';

class UserProfilePhotos extends Entity {
  int get total_count => get('total_count');
  List<List<Photo>> get photos {
    var list = getMany<List>('photos');

    return list.map((p) => Entity.generateMany<Photo>(_bot, p)).toList();
  }

  UserProfilePhotos(Bot bot, Map<String, dynamic> data) : super(bot, data);
}