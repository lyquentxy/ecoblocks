class AgentPermissionPolicy {
  final bool canUseLlm;
  final bool canScanEmbeddedDevices;
  final Set<String> callableDeviceIds;

  const AgentPermissionPolicy({
    this.canUseLlm = true,
    this.canScanEmbeddedDevices = true,
    this.callableDeviceIds = const {},
  });

  bool canCallDevice(String deviceId) => callableDeviceIds.contains(deviceId);
}
