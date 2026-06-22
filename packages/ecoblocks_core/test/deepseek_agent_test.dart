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
}
