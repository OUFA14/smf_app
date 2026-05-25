class EmergencyPersonnel {
  final String id;
  final String name;
  final String initials;
  final String zone;
  final int bpm;
  final String status;

  const EmergencyPersonnel({
    required this.id,
    required this.name,
    required this.initials,
    required this.zone,
    required this.bpm,
    required this.status,
  });

  factory EmergencyPersonnel.fromJson(Map<String, dynamic> json) {
    return EmergencyPersonnel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      initials: json['initials']?.toString() ?? '',
      zone: json['zone']?.toString() ?? '',
      bpm: (json['bpm'] ?? 0) as int,
      status: json['status']?.toString() ?? 'active',
    );
  }
}
