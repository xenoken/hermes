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

import 'dart:async';

/// [Hermes]. The messenger.
class Hermes {
  final Map<dynamic, Stream<dynamic>> _streams = <dynamic, Stream<dynamic>>{};

  final StreamController _mainstream;
  Stream _broadcastMainstream;

  static Hermes _hermes;

  Hermes._() : _mainstream = StreamController();

  static Hermes _get() {
    if (_hermes == null) {
      _hermes = Hermes._();
    }
    return _hermes;
  }

  /// [send] allows to send a message.
  static void send<T>(T message) {
    _get()._mainstream.add(message);
  }

  /// [fetch] registers callbacks for messages.
  ///
  /// whenever a message of type [T] is received, the [callback]
  /// is called.
  static fetch<T>(Function(T arg) func) {
    var i = _get();

    i._broadcastMainstream ??= i._mainstream.stream.asBroadcastStream();

    if (!i._streams.containsKey(T)) {
      i._streams[T] = i._broadcastMainstream
          .where((event) => event is T)
          .cast<T>();
    }

    i._streams[T].listen((event) {
      func(event);
    });
  }
}
