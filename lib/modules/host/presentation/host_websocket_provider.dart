import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';

final signalRProvider = Provider<HubConnection>((ref) {
  final connection = HubConnectionBuilder()
      .withUrl('https://3kb5qjd2-5353.brs.devtunnels.ms/accessconfirmationhub')
      .build();
  return connection;
});
