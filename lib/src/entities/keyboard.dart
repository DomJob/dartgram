part of '../entity.dart';

abstract class Keyboard {
  String get serialized;
}

class InlineKeyboard extends Keyboard {
  final List<List<Map>> _rows = [[]];

  @override
  String get serialized => json.encode({'inline_keyboard': _rows});

  InlineKeyboard get newRow {
    _rows.add([]);
    return this;
  }

  InlineKeyboard button(String text,
      {String url,
      String login_url,
      String callback_data,
      String switch_inline_query,
      String switch_inline_query_current_chat}) {
      
    var button = {'text': text};

    if(url != null) button['url'] = url;
    if(login_url != null) button['login_url'] = login_url;
    if(callback_data != null) button['callback_data'] = callback_data;
    if(switch_inline_query != null) button['switch_inline_query'] = switch_inline_query;
    if(switch_inline_query_current_chat != null) button['switch_inline_query_current_chat'] = switch_inline_query_current_chat;

    _rows.last.add(button);

    return this;
  }
}

class InlineKeyboardButton {
  String text;
  String url;
  String login_url;
  String callback_data;
  String switch_inline_query;
  String switch_inline_query_current_chat;

  InlineKeyboardButton(this.text, this.url, this.login_url, this.callback_data,
      this.switch_inline_query, this.switch_inline_query_current_chat);
}
