# DartGram

Intuitive Telegram API handler in Dart with minimal dependencies.

It is async-oriented, meaning every update is handled independently of the others.

It is designed to follow a set of rules defined by the user that are examined for every update. A simple syntax allows the user to specify various filters that each have to match a given message for its corresponding rule to be executed.

The entities laid out are designed to closely follow the [types](https://core.telegram.org/bots/api#available-types) as specified by the Telegram docs. Several methods are then added to render the code more fluent and intuitive to write (for example a message can be reply with .reply(text) or deleted with .delete(), a user can be kicked with .kick(), etc.)

## Usage

A simple usage example:

```dart
import 'package:dartgram/dartgram.dart';

main() async {
  var bot = Bot('12345:token');

  bot.onCommand('ping')
  .then((m) async {
    await m.reply('pong');
  });

  var isReply = (Message m) => m.reply_to_message != null;
  var isAdmin = (Message m) => m.from.id == 12345678;

  bot.onCommand('info')
  .when(isReply)
  .and(isAdmin)
  .then((m) async {
    await m.reply(m.reply_to_message.raw.toString());
  });

  await bot.start();
}
```

You can also invoke any [Telegram API](https://core.telegram.org/bots/api) endpoint manually by specifying the parameters:

```
  var message = await bot.request<Message>('sendMessage', {
    'chat_id': 178578488,
    'text': 'hi'
  });
```

The object returned will be casted directly from the response returned by Telegram into the specified type, with all its available intuitive methods (reply, delete, etc)

## Features and bugs

This is a work-in-progress and I intend on adding new features as I need them for my personal bots. If you desperately need a feature, you can request it.