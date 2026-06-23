import 'device_profile.dart';

sealed class AgentEvent {
  const AgentEvent();
}

class AgentStatusEvent extends AgentEvent {
  final String status;
  final String message;

  const AgentStatusEvent(this.status, this.message);
}

class AgentProfileEvent extends AgentEvent {
  final DeviceProfile profile;

  const AgentProfileEvent(this.profile);
}

class AgentErrorEvent extends AgentEvent {
  final String message;

  const AgentErrorEvent(this.message);
}
