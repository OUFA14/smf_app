class ReportItem {
  final String id;
  final String name;
  final String description;
  final String status; // Ready, Pending, Review
  final DateTime? generatedAt;
  final String format;

  const ReportItem({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.generatedAt,
    required this.format,
  });

  factory ReportItem.fromJson(Map<String, dynamic> json) {
    return ReportItem(
      id: json['id'].toString(),
      name: json['name'].toString(),
      description: json['description'].toString(),
      status: json['status'].toString(),
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'].toString()),
      format: json['format'].toString(),
    );
  }
}