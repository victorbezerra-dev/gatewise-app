import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dio/dio.dart';

import '../domain/interfaces/custom_http_client.dart';
import 'secure_storage.dart';

class CustomHttpClientImpl implements CustomHttpClient {
  CustomHttpClientImpl({
    required String baseUrl,
    Future<bool> Function()? onUnauthorized,
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
    _dio.interceptors.add(_LogInterceptor());
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
  }) => _dio.post(path, data: body, options: _opts(headers));

  @override
  Future<Response<dynamic>> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) => _dio.patch(path, data: body, options: _opts(headers));

  @override
  Future<Response<dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) => _dio.put(path, data: body, options: _opts(headers));

  @override
  Future<Response<dynamic>> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) => _dio.delete(path, data: body, options: _opts(headers));

  Options? _opts(Map<String, String>? headers) =>
      headers != null ? Options(headers: headers) : null;
}

class _LogInterceptor extends Interceptor {
  static const _tag = 'HTTP';
  static const _maxBody = 800;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['_startMs'] = DateTime.now().millisecondsSinceEpoch;
    dev.log(
      '→ ${options.method} ${options.path}${_body(options.data)}',
      name: _tag,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode ?? 0;
    dev.log(
      '← $status ${response.requestOptions.method} ${response.requestOptions.path}'
      ' (${_ms(response.requestOptions)}ms)${_body(response.data)}',
      name: _tag,
      level: status >= 400 ? 900 : 0,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dev.log(
      '✗ ${err.requestOptions.method} ${err.requestOptions.path}'
      ' (${_ms(err.requestOptions)}ms) [${err.type.name}] ${err.message}',
      name: _tag,
      level: 900,
      error: err,
    );
    handler.next(err);
  }

  int _ms(RequestOptions options) {
    final start = options.extra['_startMs'] as int?;
    if (start == null) return 0;
    return DateTime.now().millisecondsSinceEpoch - start;
  }

  String _body(dynamic data) {
    if (data == null) return '';
    final raw = data is String ? data : jsonEncode(data);
    if (raw.isEmpty) return '';
    return raw.length <= _maxBody ? ' $raw' : ' ${raw.substring(0, _maxBody)}…';
  }
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
  _UnauthorizedInterceptor({required this.onUnauthorized, required this.dio});

  final Future<bool> Function() onUnauthorized;
  final Dio dio;

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401 &&
        response.requestOptions.extra['_retry'] != true) {
      final refreshed = await onUnauthorized();
      if (!refreshed) {
        handler.next(response);
        return;
      }
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
