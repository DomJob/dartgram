import 'package:dartgram/dartgram.dart';

void main(List<String> args) async {
  var bot = Bot('12345:token');

  // Standalone request (executes immediately)
  // In this example the response (if successful) is casted into a Message object

  var message = await bot.request<Message>('sendMessage', {
    'chat_id': 12345678,
    'text': 'hi'
  });

  // Setting up rules (executes when the polling loop starts)

  // Simple command
  bot.onCommand('ping')
  .then((m) async {
    await m.reply('pong');
  });

  // Custom filters (can be stored and reused, etc)
  var isReply = (Message m) => m.reply_to_message != null;
  var isAdmin = (Message m) => m.from.id == 12345678;

  bot.onCommand('info')
  .when(isReply)
  .and(isAdmin)
  .then((m) async {
    await m.reply(m.reply_to_message.raw.toString());
  });

  // Handle messages that aren't commands
  bot.onMessage
  .when((m) => m.text.contains('hello'))
  .then((m) async {
    await m.reply('hi');
  });

  // Launch the update handling loop
  await bot.start();
}
