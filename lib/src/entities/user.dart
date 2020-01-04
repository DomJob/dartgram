part of '../entity.dart';

class User extends Entity {
  int id;
  bool is_bot;
  String first_name;
  String last_name;
  String username;

  final Bot _bot;

  User(this._bot, Map<String, dynamic> data) : super(data) {
    id = data['id'];
    is_bot = data['is_bot'];
    first_name = data['first_name'];
    last_name = data['last_name'];
    username = data['username'];
  }
}
