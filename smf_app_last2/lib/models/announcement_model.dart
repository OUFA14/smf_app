class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String priority;
  final String sender;
  final DateTime timestamp;
  bool isRead;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.priority,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'Medium',
      sender: json['sender']?.toString() ?? 'System',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      isRead: json['isRead'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'priority': priority,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? message,
    String? priority,
    String? sender,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}