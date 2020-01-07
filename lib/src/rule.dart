part of 'bot.dart';

typedef Body = Future<void> Function(Update u);
typedef Filter = bool Function(Update u);

class _Rule {
  final List<Filter> _filters;
  final Body _action;

  bool match(Update u) => _filters.every((Filter f) => f(u));

  Future<void> run(Update u) => _action(u);

  _Rule(this._filters, this._action);
}

class _MessageRuleBuilder {
  final Bot _bot;
  final List<Filter> _filters = [];

  _MessageRuleBuilder(this._bot, UpdateType type) {
    _filters.add((u) => u.type == type);
  }

  _MessageRuleBuilder when(bool Function(Message) filter) {
    _filters.add((u) => filter(u.message));
    return this;
  }

  _MessageRuleBuilder and(bool Function(Message) filter) => when(filter);

  void then(Future<void> Function(Message) action) {
    var rule = _Rule(_filters, (u) => action(u.message));

    _bot._rules.add(rule);
  }
}

class _CallbackRuleBuilder {
  final Bot _bot;
  final List<Filter> _filters = [];

  _CallbackRuleBuilder(this._bot) {
    _filters.add((u) => u.type == UpdateType.callback);
  }

  _CallbackRuleBuilder when(bool Function(CallbackQuery) filter) {
    _filters.add((u) => filter(u.callback_query));
    return this;
  }

  _CallbackRuleBuilder and(bool Function(CallbackQuery) filter) => when(filter);

  void then(Future<void> Function(CallbackQuery) action) {
    var rule = _Rule(_filters, (u) => action(u.callback_query));
    _bot._rules.add(rule);
  }
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