/// An ESP32 installed in a space. The backend calls it a "space controller";
/// the app uses this name so it does not clash with the spaces
/// StateNotifier.
class SpaceControllerDevice {
  const SpaceControllerDevice({
    required this.id,
    required this.spaceId,
    required this.name,
    required this.hasLock,
    required this.hasKeys,
    this.lastSeenAt,
  });

  final int id;
  final int spaceId;
  final String name;
  final bool hasLock;
  final bool hasKeys;
  final DateTime? lastSeenAt;
}
