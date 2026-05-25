class SystemStatus {
  final String systemStatus;
  final String communication;
  final String weather;
  final String network;
  final String lastUpdated;

  const SystemStatus({
    required this.systemStatus,
    required this.communication,
    required this.weather,
    required this.network,
    required this.lastUpdated,
  });

  factory SystemStatus.fromJson(Map<String, dynamic> json) {
    return SystemStatus(
      systemStatus: json['systemStatus']?.toString() ?? 'Unknown',
      communication: json['communication']?.toString() ?? 'Unknown',
      weather: json['weather']?.toString() ?? 'Unknown',
      network: json['network']?.toString() ?? 'Unknown',
      lastUpdated: json['lastUpdated']?.toString() ?? '--:--:--',
    );
  }
}
