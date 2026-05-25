class WorkInfo {
  final String jobTitle;
  final String department;
  final String manager;
  final String location;
  final String shift;
  final String certificates;
  final String safetyCourses;
  final String equipment;
  final String employmentStatus;
  final String attendanceStatus;

  const WorkInfo({
    required this.jobTitle,
    required this.department,
    required this.manager,
    required this.location,
    required this.shift,
    required this.certificates,
    required this.safetyCourses,
    required this.equipment,
    required this.employmentStatus,
    required this.attendanceStatus,
  });

  factory WorkInfo.fromJson(Map<String, dynamic> json) {
    return WorkInfo(
      jobTitle: json['jobTitle']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      manager: json['manager']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      shift: json['shift']?.toString() ?? '',
      certificates: json['certificates']?.toString() ?? '',
      safetyCourses: json['safetyCourses']?.toString() ?? '',
      equipment: json['equipment']?.toString() ?? '',
      employmentStatus: json['employmentStatus']?.toString() ?? 'Active',
      attendanceStatus: json['attendanceStatus']?.toString() ?? 'Present',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'department': department,
      'manager': manager,
      'location': location,
      'shift': shift,
      'certificates': certificates,
      'safetyCourses': safetyCourses,
      'equipment': equipment,
      'employmentStatus': employmentStatus,
      'attendanceStatus': attendanceStatus,
    };
  }
}
