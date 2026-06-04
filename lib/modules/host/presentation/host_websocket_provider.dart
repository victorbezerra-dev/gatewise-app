import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../core/config/app_config.dart';

final signalRProvider = Provider<HubConnection>((ref) {
  final connection = HubConnectionBuilder()
      .withUrl(AppConfig.accessConfirmationHubUrl)
      .build();
  return connection;
});
