import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../core/config/app_config.dart';
import '../../../core/infra/secure_storage.dart';

final signalRProvider = FutureProvider<HubConnection>((ref) async {
  return HubConnectionBuilder()
      .withUrl(
        AppConfig.accessConfirmationHubUrl,
        options: HttpConnectionOptions(
          accessTokenFactory: () async => await SecureStore.accessToken ?? '',
        ),
      )
      .withAutomaticReconnect()
      .build();
});
