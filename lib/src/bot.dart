import 'dart:convert';

import 'entities/files/file.dart';
import 'http_handler.dart';
import 'entity.dart';

part 'rule.dart';

class Bot {
  final String _token;
  HttpHandler _handler;

  int _lastUpdate = -1;
  final List<_Rule> _rules = [];
  bool _active = false;

  String parseMode = 'HTML';
  final List<String> commandCharacters = ['/', '!'];

  Bot(this._token, [this._handler]) {
    _handler ??= HttpHandler();
  }

  Future<dynamic> _request(String method, [Map<String, dynamic> params]) async {
    var result = await _handler.post(
        'https://api.telegram.org/bot${_token}/${method}', params);

    var decoded = json.decode(result);

    if (!decoded['ok']) {
      throw ApiException(method, params, decoded);
    }

    return decoded['result'];
  }

  Future<T> request<T>(String method, [Map<String, dynamic> params]) async {
    var data = await _request(method, params);

    return Entity.generate<T>(this, data);
  }

  Future<List<T>> requestMany<T>(String method,
      [Map<String, dynamic> params]) async {
    var data = await _request(method, params);

    return Entity.generateMany<T>(this, data);
  }

  Future<void> handle(Update update) async {
    for (var rule in _rules) {
      if (rule.match(update)) {
        try {
          await rule.run(update);
        } catch (e, t) {
          print('${e.runtimeType} - ${e}\n${t}');
        }
      }
    }
  }

  Future<void> start() async {
    if (_active) return;

    _active = true;
    _handler.start();

    while (_active) {
      var updates =
          await requestMany<Update>('getUpdates', {'offset': _lastUpdate + 1});

      if (updates.isNotEmpty) {
        _lastUpdate = updates.last.id;
        for (var update in updates) {
          unawaited(handle(update));
        }
      }
    }
  }

  void close() {
    _handler.close();
    _active = false;
  }

  Future<Message> sendMessage(dynamic chat_id, String text,
      {String parse_mode,
      bool disable_web_page_preview,
      bool disable_notification,
      int reply_to_message_id,
      Keyboard reply_markup}) {
    var data = {
      'parse_mode': parse_mode,
      'disable_web_page_preview': disable_web_page_preview,
      'disable_notification': disable_notification,
      'reply_to_message_id': reply_to_message_id,
      'reply_markup': reply_markup
    };
    if (reply_markup == null) data.remove('reply_markup');

    return request<Message>('sendMessage', data);
  }

  Future<User> getMe() => request<User>('getMe');

  Future<Chat> getChat(int chat_id) =>
      request<Chat>('getChat', {'chat_id': chat_id});

  Future<void> downloadFile(String file_path, String local_path) async {
    await _handler.download(
        'https://api.telegram.org/file/bot$_token/$file_path', local_path);
  }

  T loadFile<T extends File>(String id, {bool local = false}) =>
      File.load<T>(this, id, local);

  _RepeatedAction every(int seconds, Future Function() action) =>
      _RepeatedAction(Duration(seconds: seconds), action);

  _MessageRuleBuilder get onMessage =>
      _MessageRuleBuilder(this, UpdateType.message);

  _MessageRuleBuilder get onEditedMessage =>
      _MessageRuleBuilder(this, UpdateType.edited);

  _MessageRuleBuilder get onChannelPost =>
      _MessageRuleBuilder(this, UpdateType.channel);

  _MessageRuleBuilder get onEditedChannelPost =>
      _MessageRuleBuilder(this, UpdateType.edited_channel);

  _CallbackRuleBuilder get onCallbackQuery => _CallbackRuleBuilder(this);

  _MessageRuleBuilder onCommand(String cmd) =>
      _MessageRuleBuilder(this, UpdateType.message)
        ..when((m) => m.command?.toLowerCase() == cmd.toLowerCase())
        ..and((m) => !m.is_forward);
}

class ApiException implements Exception {
  String method;
  Map<String, dynamic> params;
  Map<String, dynamic> result;

  ApiException(this.method, this.params, this.result);

  @override
  String toString() {
    var encoder = JsonEncoder.withIndent(' ');
    return 'Method: $method\nParams: ${encoder.convert(params)}\n\nResult:\n${encoder.convert(result)}';
  }
}

void unawaited(Future future) {}
