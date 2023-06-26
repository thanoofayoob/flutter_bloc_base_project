import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_base_project/src/common/utils/app_configs.dart';
import 'package:flutter_bloc_base_project/src/common/utils/app_exceptions.dart';

import 'end_points.dart';

class DioClient {
  final Dio _dio;
  DioClient(this._dio) {
    initialiseDio();
  }
  initialiseDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      // receiveTimeout: 10000,
      contentType: Headers.jsonContentType,
      followRedirects: false,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
      },
      validateStatus: (status) {
        if (status != null) {
          return status < 500;
        } else {
          return false;
        }
      },
    );

    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ));
  }

  Future<Response> request(
      {required EndPoint endPoint,
      dynamic data,
      Map<String, dynamic>? queryParams,
      String urlParams = ''}) async {
    late Response response;

    if (endPoint.shouldAddToken == true) {
      //please add token here
      var userCredential = '';

      _dio.options.headers = {'Authorization': 'Bearer $userCredential'};
    }

    try {
      switch (endPoint.requestType) {
        case RequestType.get:
          response = await _dio.get(endPoint.url + urlParams,
              queryParameters: data ?? queryParams);
          break;
        case RequestType.post:
          response = await _dio.post(endPoint.url + urlParams,
              data: data, queryParameters: queryParams);
          break;
        case RequestType.patch:
          response = await _dio.patch(endPoint.url + urlParams,
              data: data, queryParameters: queryParams);
          break;
        case RequestType.put:
          response = await _dio.put(endPoint.url + urlParams,
              data: data, queryParameters: queryParams);
          break;

        case RequestType.delete:
          response = await _dio.delete(endPoint.url + urlParams, data: data);
      }
    } on DioException catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw FetchDataException('Timeout Error\n\n${error.message}');

        case DioExceptionType.cancel:
          throw FetchDataException('Request Cancelled\n\n${error.message}');
        case DioExceptionType.unknown:
          String message = error.message!.contains('SocketException')
              ? 'No Internet Connection'
              : 'Oops, Something went wrong';
          kDebugMode
              ? throw FetchDataException('$message\n\n${error.message}')
              : throw FetchDataException(message);
      }
    }
    return response;
  }
}

class ApiResponse<T> {
  ApiResponseStatus status;
  T? data;
  String? message;
  ApiResponse.idle() : status = ApiResponseStatus.idle;
  ApiResponse.loading(this.message) : status = ApiResponseStatus.loading;
  ApiResponse.completed(this.data) : status = ApiResponseStatus.completed;
  ApiResponse.unProcessable(this.message)
      : status = ApiResponseStatus.unProcessable;
  ApiResponse.error(this.message) : status = ApiResponseStatus.error;
  @override
  String toString() {
    return 'ApiResponseStatus : $status \n Message : $message \n Data : $data';
  }
}

enum ApiResponseStatus { idle, loading, completed, unProcessable, error }
