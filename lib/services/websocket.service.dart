import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:rxdart/rxdart.dart';

import '../models/json-convertable.model.dart';
import '../constants/api-routes.constants.dart';

class WebSocketService {

  static final channel = IOWebSocketChannel.connect(ApiRoutes.websocketUrl);
  static final events = new Observable(channel.stream.asBroadcastStream());
  static final jsonEncoder = JsonEncoder();
  static final dataMatchExp = new RegExp(r",(.*)]");

  static bool islistening = false;

  static void emit(String eventName, JSONConvertable data) {
    String eventStr = jsonEncoder.convert({'event': eventName, 'data': data.toJson()});
    channel.sink.add(eventStr);
  }

  static Observable listen(String eventName) {
    return events
      .map((eventStr) => jsonDecode(eventStr))
      .where((event) => event['event'] == eventName);
  }
  
}
