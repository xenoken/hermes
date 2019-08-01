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
abstract class Hermes {
  static Map<dynamic, Stream<dynamic>> _streams = <dynamic, Stream<dynamic>>{};

  static final StreamController _mainstream = StreamController();
  static Stream _bcmainstream = _mainstream.stream.asBroadcastStream();

  /// [send] allows to send a message.
  static void send<T>(T message) {
    _mainstream.add(message);
  }

  /// [fetch] registers callbacks for messages.
  ///
  /// whenever a message of type [T] is received, the [func] callback
  /// is called.
  /// returns a [FetchOperation] that allows to 'unfetch' the message,
  /// Releasing memory resources and preventing memory leaks.
  static FetchOperation fetch<T>(Function(T arg) func) {
    if (!_streams.containsKey(T) || _streams[T] == null) {
      _streams[T] = _bcmainstream.where((event) => event is T);
    }

    var _ss = _streams[T].listen((event) {
      func(event);
    });

    return FetchOperation._(_ss);
  }

  /// [unfetch] cancels a previous fetch call..
  ///
  /// [unfetch]ing a message, releases memory resources
  /// and prevents memory leaks.
  /// returns true if the operation was successfully unfetched, false otherwise.
  static Future<bool> unfetch(FetchOperation operation) async {
    if (operation == null || operation._streamSubscription == null) {
      return false;
    }

    await operation._streamSubscription.cancel();

    return true;
  }
}

/// [FetchOperation] represents a reference to a successful fetch operation.
/// With an instance of [FetchOperation]
/// it is possible to cancel the fetch operation
/// and release resources, preventing memory leaks.
class FetchOperation {
  final StreamSubscription _streamSubscription;

  FetchOperation._(this._streamSubscription);
}
