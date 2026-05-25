class IncidentFeedItem {
  final String time;
  final String description;
  final String location;
  final String type;
  final String icon;

  const IncidentFeedItem({
    required this.time,
    required this.description,
    required this.location,
    required this.type,
    required this.icon,
  });

  factory IncidentFeedItem.fromJson(Map<String, dynamic> json) {
    return IncidentFeedItem(
      time: json['time']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      type: json['type']?.toString() ?? 'info',
      icon: json['icon']?.toString() ?? 'info',
    );
  }
}
