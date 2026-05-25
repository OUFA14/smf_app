class UserStats {
  final int alertsHandled;
  final int zonesMonitored;
  final int reportsGenerated;
  final int daysActive;

  const UserStats({
    required this.alertsHandled,
    required this.zonesMonitored,
    required this.reportsGenerated,
    required this.daysActive,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      alertsHandled: (json['alertsHandled'] ?? 0) as int,
      zonesMonitored: (json['zonesMonitored'] ?? 0) as int,
      reportsGenerated: (json['reportsGenerated'] ?? 0) as int,
      daysActive: (json['daysActive'] ?? 0) as int,
    );
  }
}