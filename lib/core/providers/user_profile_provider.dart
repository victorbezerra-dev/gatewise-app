import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/user_entity.dart';
import '../infra/secure_storage.dart';

final userProfileProvider = FutureProvider<User?>((ref) async {
  final userJson = await SecureStore.getUserJson();
  if (userJson == null) return null;
  return User.fromJson(json.decode(userJson));
});
