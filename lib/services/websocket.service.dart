import 'dart:convert';
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

import 'package:mimos/models/index.dart';
import 'package:mimos/constants/index.dart';

class WebSocketService {

  static IOWebSocketChannel _socket;
  static StreamSubscription _socketSubscription;
  static Observable _socketEvents;
  static final _onReconnectSubject = new BehaviorSubject();

  static final jsonEncoder = JsonEncoder();
  static final dataMatchExp = new RegExp(r",(.*)]");

  static void emit(String eventName, JSONConvertable data) {
    _ensureSocket();

    String eventStr = jsonEncoder.convert({'event': eventName, 'data': data.toJson()});
    _socket.sink.add(eventStr);
  }

  static Observable listen(String eventName) {
    _ensureSocket();

    return _socketEvents
      .map((eventStr) => jsonDecode(eventStr))
      .where((event) => event['event'] == eventName);
  }

  static StreamSubscription onReconnect(void callback()) {
    callback();
    return _onReconnectSubject.listen((_) {
      callback();
    });
  }

  static _ensureSocket() {
    if (_socket == null) { _initSocket(); }
  }

  static _initSocket() {
    _socket = IOWebSocketChannel.connect(ApiRoutes.websocketUrl);
    _socketEvents = new Observable(_socket.stream.asBroadcastStream());

    if (_socketSubscription != null) { _socketSubscription.cancel(); }
    _socketSubscription = _socketEvents.listen(
      (dynamic message) {
        print('ws message: $message');
      },
      onDone: () {
        print('ws channel closed');

        _initSocket();
        _onReconnectSubject.add({});
      },
      onError: (error) {
        print('ws error: $error');
      },
    );
  }
  
}
