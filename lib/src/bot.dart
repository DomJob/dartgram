import 'dart:convert';

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

  Future<dynamic> _request(String method,
      [Map<String, dynamic> params, Map<String, String> files]) async {
    var result = await _handler.post(
        'https://api.telegram.org/bot${_token}/${method}', params, files);

    var decoded = json.decode(result);

    if (!decoded['ok']) {
      throw ApiException(method, params, files, decoded);
    }

    return decoded['result'];
  }

  Future<T> request<T>(String method,
      [Map<String, dynamic> params, Map<String, String> files]) async {
    var data = await _request(method, params, files);

    return Entity.generate<T>(this, data);
  }

  Future<List<T>> requestMany<T>(String method,
      [Map<String, dynamic> params, Map<String, String> files]) async {
    var data = await _request(method, params, files);

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

  Future<User> getMe() => request<User>('getMe');

  Future<Chat> getChat(int chat_id) =>
      request<Chat>('getChat', {'chat_id': chat_id});

  Future<void> downloadFile(String file_path, String local_path) async {
    await _handler.download('https://api.telegram.org/file/bot$_token/$file_path', local_path);
  }

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
  Map<String, String> files;
  Map<String, dynamic> result;

  ApiException(this.method, this.params, this.files, this.result);

  @override
  String toString() {
    var encoder = JsonEncoder.withIndent(' ');
    return 'Method: $method\nParams: ${encoder.convert(params)}\nFiles: ${files}\n\nResult:\n${encoder.convert(result)}';
  }
}

void unawaited(Future future) {}
