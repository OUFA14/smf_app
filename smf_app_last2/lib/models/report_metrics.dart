class ReportMetrics {
  final int incidentReports;
  final int complianceScore;
  final int pendingExports;
  final int criticalFindings;

  const ReportMetrics({
    required this.incidentReports,
    required this.complianceScore,
    required this.pendingExports,
    required this.criticalFindings,
  });

  factory ReportMetrics.fromJson(Map<String, dynamic> json) {
    return ReportMetrics(
      incidentReports: (json['incidentReports'] ?? 0) as int,
      complianceScore: (json['complianceScore'] ?? 0) as int,
      pendingExports: (json['pendingExports'] ?? 0) as int,
      criticalFindings: (json['criticalFindings'] ?? 0) as int,
    );
  }
}