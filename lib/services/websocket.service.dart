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

  static void emit(String eventName, JSONConvertable data) {
    String dataStr = jsonEncoder.convert(data.toJson());
    channel.sink.add('42["$eventName",$dataStr]');
  }

  static Observable listen(String eventName) {
    return events.where((dataStr) => dataStr.startsWith('42["$eventName",'))
      .map((dataStr) => json.decode(dataMatchExp.firstMatch(dataStr).group(1)));
  }
  
}
