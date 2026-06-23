import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'agent_event.dart';
import 'device_agent.dart';
import 'device_profile.dart';
import 'scanned_device.dart';

class DeepSeekConfig {
  final String apiKey;
  final String model;
  final String baseUrl;

  const DeepSeekConfig({
    required this.apiKey,
    this.model = 'deepseek-v4-flash',
    this.baseUrl = 'https://api.deepseek.com',
  });
}

class DeepSeekAgent implements DeviceAgent {
  final DeepSeekConfig config;
  final http.Client client;

  DeepSeekAgent({
    required this.config,
    http.Client? client,
  }) : client = client ?? http.Client();

  @override
  Stream<AgentEvent> profile(List<ScannedDevice> devices) async* {
    yield const AgentStatusEvent(
        'profiling', 'DeepSeek agent profiling devices');
    for (final device in devices) {
      final profile = await profileOne(device);
      yield AgentProfileEvent(profile);
    }
    yield const AgentStatusEvent('done', 'DeepSeek profiling done');
  }

  Future<DeviceProfile> profileOne(ScannedDevice device) async {
    final response = await client
        .post(
          Uri.parse('${config.baseUrl}/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${config.apiKey}',
          },
          body: jsonEncode(buildRequestBody(device)),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('DeepSeek HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>?;
    String? content;
    if (choices != null && choices.isNotEmpty) {
      final choice = choices.first as Map<String, dynamic>;
      final message = choice['message'] as Map<String, dynamic>?;
      content = message?['content'] as String?;
    }
    if (content == null || content.trim().isEmpty) {
      throw const FormatException('DeepSeek returned empty content');
    }

    final json = jsonDecode(content) as Map<String, dynamic>;
    return DeviceProfile.fromJson({
      'device_id': json['device_id'] ?? device.id,
      'type': json['type'],
      'capability': json['capability'],
      'task': json['task'],
    });
  }

  Map<String, dynamic> buildRequestBody(ScannedDevice device) => {
        'model': config.model,
        'response_format': {'type': 'json_object'},
        'messages': [
          {
            'role': 'system',
            'content':
                'You are EcoBlocks Hardware Agent. Return only JSON with keys: device_id, type, capability, task. Do not include GPIO, protocol fields, confidence, or reason.',
          },
          {
            'role': 'user',
            'content': jsonEncode({
              'device': device.toJson(),
              'instruction':
                  'Profile this scanned ecosystem device and assign one abstract task.',
            }),
          },
        ],
      };
}
