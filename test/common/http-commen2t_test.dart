import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../lib/common/ApiService.dart';

void main() {
  const successMessage = {'message': 'Success'};
  const errorMessage = {'message': 'error'};
  const testPath = 'test';
  const testData = {'data': 'sample data'};
  const header = {'Content-Type': 'application/json'};

  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  var baseUrl;

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
    baseUrl = 'https://example.com/';
  });

  test('- Get Method Success test', () async {
    dioAdapter.onGet(
      '$baseUrl$testPath',
      (request) {
        return request.reply(200, successMessage);
      },
      data: null,
      queryParameters: {},
      headers: {},
    );

    final service = ApiService(
      dio: dio,
    );

    final response = await service.get('test');

    expect(response, successMessage);
  });

  test('- Post Method Success test', () async {
    dioAdapter.onPost(
      '$baseUrl$testPath',
      (request) {
        return request.reply(201, successMessage);
      },
      data: json.encode(testData),
      queryParameters: {},
      headers: header,
    );

    final service = ApiService(
      dio: dio,
    );

    final response = await service.post('test', json.encode(testData));

    expect(response, successMessage);
  });
}
