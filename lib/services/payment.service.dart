import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/io.dart';
import '../models/table-item-pay.model.dart';

final channel = IOWebSocketChannel.connect('wss://restaurant-payments-api.herokuapp.com/socket.io/?EIO=3&transport=websocket');
final jsonEncoder = JsonEncoder();

payForItems(TableItemPayModel itemPay) {
  String jsonStr = jsonEncoder.convert(itemPay.toJson());
  channel.sink.add('42["pay_for_item",$jsonStr]');
}

Stream<dynamic> itemPays() {
  return channel.stream;
}
