import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:test/test.dart';

void main() {
  test('DeepSeek request body uses v4 flash and JSON mode', () {
    final agent = DeepSeekAgent(
      config: const DeepSeekConfig(apiKey: 'sk-test'),
    );

    final body = agent.buildRequestBody(
      const ScannedDevice(
          id: 'mock-temp-01', name: 'EB-Temp-01', source: 'mock'),
    );

    expect(body['model'], 'deepseek-v4-flash');
    expect(body['response_format'], {'type': 'json_object'});
    expect(body['messages'], isA<List<dynamic>>());
  });

  test('DeepSeek connection test reports success for 2xx response', () async {
    final agent = DeepSeekAgent(
      config: const DeepSeekConfig(apiKey: 'sk-test'),
      client: MockClient((request) async {
        expect(request.url.toString(),
            'https://api.deepseek.com/chat/completions');
        expect(request.headers['Authorization'], 'Bearer sk-test');
        return http.Response('{"choices":[]}', 200);
      }),
    );

    final result = await agent.testConnection();

    expect(result.success, isTrue);
  });

  test('DeepSeek connection test reports failure for non-2xx response',
      () async {
    final agent = DeepSeekAgent(
      config: const DeepSeekConfig(apiKey: 'sk-test'),
      client: MockClient((request) async {
        return http.Response('unauthorized', 401);
      }),
    );

    final result = await agent.testConnection();

    expect(result.success, isFalse);
    expect(result.message, contains('401'));
  });
}
