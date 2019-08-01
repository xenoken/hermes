/*
 * BSD 3-Clause License
 *
 * Copyright (c) 2019, Kennedy Tochukwu Ekeoha All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 */

import 'package:hermes/hermes.dart';
import 'package:test/test.dart';

import 'dart:cli';

class TestMessage {
  final String content;

  TestMessage(this.content);
}

void main() {
  group("Mercury", () {
    //
    test('receive', () async {
      Hermes.fetch<TestMessage>((message) {
        expect((message.runtimeType == TestMessage), isTrue);
      });
    });

    //
    test('Fetch - is Typed', () async {
      Hermes.fetch<TestMessage>((message) {
        expect((message.runtimeType == TestMessage), isTrue);
      });

      Hermes.send<TestMessage>(TestMessage(""));
    });

    //
    test('Fetch - Multiple fetches - same message type', () async {
      Hermes.fetch<TestMessage>((message) {
        print('first: received ${message.content}');
        expect((message.runtimeType == TestMessage), isTrue);
      });

      Hermes.fetch<TestMessage>((message) {
        print('second: received ${message.content}');
        expect((message.runtimeType == TestMessage), isTrue);
      });

      Hermes.send<TestMessage>(TestMessage('Hello!'));
    });

    //
    test('Fetch - Multiple fetches - different message types', () async {
      Hermes.fetch<TestMessage>((message) {
        print('first: received ${message.content}');
        expect((message.runtimeType == TestMessage), isTrue);
      });

      Hermes.fetch<int>((message) {
        print('second: received ${message.toString()}');
        expect((message.runtimeType == int), isTrue);
      });

      Hermes.send<TestMessage>(TestMessage('Hello!'));
      Hermes.send<int>(42);
    });

    //
    test('Unfetch', () async {
      var handle = Hermes.fetch<TestMessage>((message) {
        print('Unfetch: received ${message.content}');
      });

      var unfetched = await Hermes.unfetch(handle);

      Hermes.send(TestMessage('Hello!'));

      expect(unfetched, isTrue);
    });

    //
    test('Fetch and Unfetch - Multiple fetches - different message types',
        () async {
      var op1 = Hermes.fetch<TestMessage>((message) {
        print('Fetch and Unfetch: first: received ${message.content}');
        expect((message.runtimeType == TestMessage), isTrue);
      });

      var op2 = Hermes.fetch<int>((message) {
        print('Fetch and Unfetch: second: received ${message.toString()}');
        expect((message.runtimeType == int), isTrue);
      });

      Hermes.send<TestMessage>(TestMessage('Hello!'));
      Hermes.send<int>(42);

      // wait some seconds to make sure that the messages arrive.
      waitFor(Future.delayed(Duration(seconds: 4)));

      await Hermes.unfetch(op1);
      await Hermes.unfetch(op2);
    });
  });
}
