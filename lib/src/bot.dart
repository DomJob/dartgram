import 'dart:convert';
import 'dart:io';

import 'entity.dart';

part 'rule.dart';

class Bot {
  final String _token;
  HttpClient _client;
  int _lastUpdate = -1;

  final List<_Rule> _rules = [];
  bool _active = false;

  String parseMode = 'HTML';

  Bot(this._token);

  Future<dynamic> _request(String method, [Map<String, dynamic> params]) async {
    if (!_active) {
      _client = HttpClient();
    }

    var url = Uri.parse('https://api.telegram.org/bot${_token}/${method}');

    var request = await _client.postUrl(url);
    request.headers.add('content-type', 'application/json; charset=utf-8');

    request.write(json.encode(params));

    var response = await request.close();

    var stream = response.transform(Utf8Decoder());
    String stringBody;
    await for (stringBody in stream) {
      ;
    }

    if (!_active) {
      _client.close();
    }

    var decoded = json.decode(stringBody);

    if (!decoded['ok']) {
      var encoder = JsonEncoder.withIndent(' ');
      var prettyData = encoder.convert(params);
      var prettyResult = encoder.convert(decoded);

      throw ApiException(
          'Method: ${method}\n\nData: ${prettyData}\n\nResult: ${prettyResult}',
          decoded);
    }

    return decoded['result'];
  }

  Future<T> request<T>(String method,
      [Map<String, dynamic> params]) async {
    var data = await _request(method, params);

    return Entity.generate<T>(this, data);
  }

  Future<List<T>> requestMany<T>(String method, [Map<String, dynamic> params]) async {
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
    _active = true;
    _client = HttpClient();

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
    _client.close();
    _active = false;
  }

  _RepeatedAction every(int seconds, Future Function() action) =>
      _RepeatedAction(Duration(seconds: seconds), action);

  _MessageRuleBuilder get onMessage => _MessageRuleBuilder(this, UpdateType.message);

  _MessageRuleBuilder get onEditedMessage => _MessageRuleBuilder(this, UpdateType.edited);

  _MessageRuleBuilder get onChannelPost => _MessageRuleBuilder(this, UpdateType.channel);

  _MessageRuleBuilder get onEditedChannelPost => _MessageRuleBuilder(this, UpdateType.edited_channel);

  _CallbackRuleBuilder get onCallbackQuery => _CallbackRuleBuilder(this);

  _MessageRuleBuilder onCommand(String cmd) => _MessageRuleBuilder(this, UpdateType.message)
    ..when((m) => m.command?.toLowerCase() == cmd.toLowerCase())
    ..and((m) => !m.is_forward);
}

class ApiException implements Exception {
  String message;
  Map<String, dynamic> data;
  ApiException(this.message, this.data);

  @override
  String toString() => message;
}

class _RepeatedAction {
  final Duration _duration;
  final Future Function() _action;
  bool active = true;

  _RepeatedAction(this._duration, this._action) {
    start();
  }

  void stop() => active = false;

  void start() {
    active = true;
    unawaited(_loop());
  }

  Future<void> _loop() async {
    while (active) {
      await Future.delayed(_duration, () async {
        if (active) await _action();
      });
    }
  }
}

void unawaited(Future future) {}
