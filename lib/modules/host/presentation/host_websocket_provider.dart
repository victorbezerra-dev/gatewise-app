import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../core/config/app_config.dart';
import '../../../core/infra/secure_storage.dart';

final signalRProvider = FutureProvider<HubConnection>((ref) async {
  final token = await SecureStore.accessToken;

  var url = AppConfig.accessConfirmationHubUrl;
  if (token != null && token.isNotEmpty) {
    final separator = url.contains('?') ? '&' : '?';
    url = '$url${separator}access_token=${Uri.encodeComponent(token)}';
  }

  return HubConnectionBuilder().withUrl(url).build();
});
