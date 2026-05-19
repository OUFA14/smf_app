class RecentReport {
  final String id;
  final String name;
  final String description;
  final String status;
  final DateTime createdAt;
  final String fileUrl;

  const RecentReport({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.fileUrl,
  });

  factory RecentReport.fromJson(Map<String, dynamic> json) {
    return RecentReport(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      fileUrl: json['fileUrl']?.toString() ?? '',
    );
  }
}