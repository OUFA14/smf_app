class Alert {
  final String id;
  final String title;
  final String description;
  final String severity; // High, Medium, Low
  final String status;   // open, investigating, acknowledged, resolved, closed
  final DateTime time;

  const Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.time,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'Low',
      status: json['status']?.toString() ?? 'open',
      time: json['time'] != null
          ? DateTime.parse(json['time'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity,
      'status': status,
      'time': time.toIso8601String(),
    };
  }
}