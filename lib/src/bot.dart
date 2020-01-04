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

  String parse_mode = 'HTML';

  Bot(this._token);

  void close() {
    _client.close();
    _active = false;
  }

  Future<dynamic> _request(String method, [Map<String, dynamic> params]) async {
    if(!_active) {
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

    if(!_active) {
      _client.close();
    }

    var decoded = json.decode(stringBody);

    if (!decoded['ok']) {
      var encoder = JsonEncoder.withIndent(' ');
      var prettyData = encoder.convert(params);
      var prettyResult = encoder.convert(decoded);

      throw ApiException('Method: ${method}\n\nData: ${prettyData}\n\nResult: ${prettyResult}', decoded);
    }

    return decoded['result'];
  }

  Future<T> request<T extends Entity>(String method, [Map<String, dynamic> params]) async {
    var data = await _request(method, params);
    
    return Entity.generate<T>(this, data);
  }

  Future<void> handle(Update update) async {
    for (var rule in _rules) {
      if(rule.match(update)) {
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

    while(_active) {
      var updates = await getUpdates();
      
      for(var update in updates) {
        unawaited(handle(update));
      }
    }
  }

  _MessageRuleBuilder get onMessage => _MessageRuleBuilder(this)
                                      .._filters.add((u) => u.type == UpdateType.message);

  _MessageRuleBuilder get onEditedMessage => _MessageRuleBuilder(this)
                                            .._filters.add((u) => u.type == UpdateType.edited);
  
  _MessageRuleBuilder get onChannelPost => _MessageRuleBuilder(this)
                                            .._filters.add((u) => u.type == UpdateType.channel);

  _MessageRuleBuilder get onEditedChannelPost => _MessageRuleBuilder(this)
                                                .._filters.add((u) => u.type == UpdateType.edited_channel);

  _MessageRuleBuilder onCommand(String cmd) => _MessageRuleBuilder(this)
                                              ..when((m) => m.command?.toLowerCase() == cmd.toLowerCase());
  
  _CallbackRuleBuilder get onCallbackQuery => _CallbackRuleBuilder(this);

  // API Endpoints

  Future<List<Update>> getUpdates() async {
    List<dynamic> rawUpdates = await request('getUpdates', {'offset': _lastUpdate + 1});

    var list = rawUpdates.map((dynamic u) => Update(this, u)).toList();
    if (list.isEmpty) return [];

    _lastUpdate = list.last.id;
    return list;
  }
}

class ApiException implements Exception {
  String message;
  Map<String, dynamic> data;
  ApiException(this.message, this.data);

  @override
  String toString() => message;
}

void unawaited(Future<void> future) {}