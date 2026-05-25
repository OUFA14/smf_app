class EmergencyStatus {
  final String mode;
  final int level;
  final bool teamsNotified;
  final String timeElapsed;
  final String zone;
  final String responseTime;
  final int unitsDeployed;
  final String status;

  const EmergencyStatus({
    required this.mode,
    required this.level,
    required this.teamsNotified,
    required this.timeElapsed,
    required this.zone,
    required this.responseTime,
    required this.unitsDeployed,
    required this.status,
  });

  factory EmergencyStatus.fromJson(Map<String, dynamic> json) {
    return EmergencyStatus(
      mode: json['mode']?.toString() ?? 'INACTIVE',
      level: (json['level'] ?? 1) as int,
      teamsNotified: json['teamsNotified'] == true,
      timeElapsed: json['timeElapsed']?.toString() ?? '00:00',
      zone: json['zone']?.toString() ?? 'Unknown',
      responseTime: json['responseTime']?.toString() ?? '--:--',
      unitsDeployed: (json['unitsDeployed'] ?? 0) as int,
      status: json['status']?.toString() ?? 'UNKNOWN',
    );
  }
}
