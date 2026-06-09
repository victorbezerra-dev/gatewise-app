import 'package:dio/dio.dart';

import '../domain/interfaces/custom_http_client.dart';
import 'secure_storage.dart';

class CustomHttpClientImpl implements CustomHttpClient {
  CustomHttpClientImpl({
    required String baseUrl,
    Future<void> Function()? onUnauthorized,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (_) => true,
      ),
    );
    _dio.interceptors.add(_AuthInterceptor());
    if (onUnauthorized != null) {
      _dio.interceptors.add(
        _UnauthorizedInterceptor(onUnauthorized: onUnauthorized, dio: _dio),
      );
    }
  }

  late final Dio _dio;

  @override
  Future<Response<dynamic>> get(String path, {Map<String, String>? headers}) =>
      _dio.get(path, options: _opts(headers));

  @override
  Future<Response<dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      _dio.post(path, data: body, options: _opts(headers));

  @override
  Future<Response<dynamic>> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      _dio.patch(path, data: body, options: _opts(headers));

  @override
  Future<Response<dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      _dio.put(path, data: body, options: _opts(headers));

  @override
  Future<Response<dynamic>> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      _dio.delete(path, data: body, options: _opts(headers));

  Options? _opts(Map<String, String>? headers) =>
      headers != null ? Options(headers: headers) : null;
}

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStore.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _UnauthorizedInterceptor extends Interceptor {
  _UnauthorizedInterceptor({
    required this.onUnauthorized,
    required this.dio,
  });

  final Future<void> Function() onUnauthorized;
  final Dio dio;

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401 &&
        response.requestOptions.extra['_retry'] != true) {
      await onUnauthorized();
      final opts = response.requestOptions..extra['_retry'] = true;
      try {
        handler.resolve(await dio.fetch(opts));
      } on DioException catch (e) {
        handler.reject(e);
      }
      return;
    }
    handler.next(response);
  }
}
