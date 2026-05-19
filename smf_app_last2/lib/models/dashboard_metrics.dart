class DashboardMetrics {
  final int totalUsers;
  final int activeUsers;
  final int totalDevices;
  final int onlineDevices;
  final int activeAlerts;
  final int sosActivations;
  final int incidentsToday;

  const DashboardMetrics({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalDevices,
    required this.onlineDevices,
    required this.activeAlerts,
    required this.sosActivations,
    required this.incidentsToday,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalUsers: (json['totalUsers'] ?? 0) as int,
      activeUsers: (json['activeUsers'] ?? 0) as int,
      totalDevices: (json['totalDevices'] ?? 0) as int,
      onlineDevices: (json['onlineDevices'] ?? 0) as int,
      activeAlerts: (json['activeAlerts'] ?? 0) as int,
      sosActivations: (json['sosActivations'] ?? 0) as int,
      incidentsToday: (json['incidentsToday'] ?? 0) as int,
    );
  }
}