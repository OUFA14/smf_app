import 'api_service.dart';
import 'auth_service.dart';
import '../Screens/announcements/announcement_model.dart';

class AnnouncementsService {
  AnnouncementsService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await _apiService.get(
      '/announcements/',
      headers: await AuthService.instance.authHeaders(),
    );

    final data = response.data;
    final List<dynamic> list = data is List
        ? data
        : data is Map<String, dynamic>
            ? data['items'] as List<dynamic>? ??
                data['data'] as List<dynamic>? ??
                data['announcements'] as List<dynamic>? ??
                []
            : [];

    return list
        .whereType<Map<String, dynamic>>()
        .map((item) => AnnouncementModel.fromJson(item))
        .toList();
  }

  Future<AnnouncementModel> createAnnouncement({
    required String title,
    required String message,
    required String priority,
    required String sender,
  }) async {
    final response = await _apiService.post(
      '/announcements/',
      headers: await AuthService.instance.authHeaders(),
      body: {
        'title': title,
        'message': message,
        'priority': priority,
        'sender': sender,
      },
    );

    return AnnouncementModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AnnouncementModel> updateAnnouncement({
    required String id,
    required String title,
    required String message,
    required String priority,
  }) async {
    final response = await _apiService.put(
      '/announcements/$id',
      headers: await AuthService.instance.authHeaders(),
      body: {
        'title': title,
        'message': message,
        'priority': priority,
      },
    );

    return AnnouncementModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _apiService.delete(
      '/announcements/$id',
      headers: await AuthService.instance.authHeaders(),
    );
  }
}
