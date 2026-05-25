class IncidentStep {
  final String name;
  final String time;
  final bool completed;

  IncidentStep({
    required this.name,
    required this.time,
    required this.completed,
  });

  factory IncidentStep.fromJson(Map<String, dynamic> json) {
    return IncidentStep(
      name: json['name']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      completed: json['completed'] == true,
    );
  }
}

class ActiveIncident {
  final String title;
  final String location;
  final DateTime reportedAt;
  final String incidentId;
  final List<IncidentStep> steps;

  const ActiveIncident({
    required this.title,
    required this.location,
    required this.reportedAt,
    required this.incidentId,
    required this.steps,
  });

  factory ActiveIncident.fromJson(Map<String, dynamic> json) {
    final stepsList = json['steps'] as List? ?? [];
    return ActiveIncident(
      title: json['title']?.toString() ?? 'No active incident',
      location: json['location']?.toString() ?? 'Unknown',
      reportedAt: json['reportedAt'] != null
          ? DateTime.parse(json['reportedAt'].toString())
          : DateTime.now(),
      incidentId: json['incidentId']?.toString() ?? 'N/A',
      steps: stepsList
          .whereType<Map<String, dynamic>>()
          .map(IncidentStep.fromJson)
          .toList(),
    );
  }
}
