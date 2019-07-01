Messaging library for Dart. Nimble and efficient like the messenger of the Gods.

# What is it

Hermes is a simple but powerful way to send and receive messages across a Dart App.
For those who are experienced Publish/subscribe messaging and event subscriptions, Hermes's mechanism will look very familiar.
One cool thing about Hermes is the ability to setup a pub\sub architecture with only *two lines* of code.
Divine.

Hermes encapsulates the idea of event or signal (concept found in other messaging or eventing systems)
with the loose concept of Message.

You can send a message from any position in your code. Hermes handles the task of carrying the message to all recipients that
are waiting for the message.

In the same way you can send a Message from anywhere, You are able to receive a message sent from anywhere too.

For Hermes any object can act as a Message. Primitives, Functions, Built-in Types, Custom Types...*Anything*.

Hermes doesn't have the concept of registration. Everything is handled transparently. The moment your code wants to fetch a message, it automatically registers itself to receive it.


## How to Use it

To send a message just call the _send_ function.
```dart
Hermes.send<T>(message);
// or
Hermes.send(T message);
```

To receive a message just call the _fetch_ function.
```dart
Hermes.fetch<T>(message, (T message){ });
// or
Hermes.fetch(T message, (T message){ });
```

Note that _fetch_ acts like a transparent registration mechanism: when You call _fetch_ the specified handler function will be called whenever a new message of type T arrives.


A simple usage example:

```dart
import 'package:hermes/hermes.dart';

class Message {
  final String content;
  Message(this.content);
}

main() {
  // registers a callback that is called when the message is received.
  Hermes.receive((Message message) {
    print("Message received. it says: '${message.content}'");
  });

  // send a message
  Hermes.send(Message("Hello World!"));
}

```

## Remarks

- _Hermes.send_ and _Hermes.receive_ are synchronous functions, but the message handler can be async.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://www.github.com/xenoken/hermes/issues
