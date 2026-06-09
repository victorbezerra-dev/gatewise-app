import 'package:dio/dio.dart';

abstract class CustomHttpClient {
  Future<Response<dynamic>> get(String path, {Map<String, String>? headers});

  Future<Response<dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<Response<dynamic>> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<Response<dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<Response<dynamic>> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
  });
}
