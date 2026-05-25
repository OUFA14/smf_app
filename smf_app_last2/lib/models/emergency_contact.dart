class EmergencyContact {
  final String id;
  final String name;
  final String number;
  final String type;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.number,
    required this.type,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      type: json['type']?.toString() ?? 'other',
    );
  }
}
