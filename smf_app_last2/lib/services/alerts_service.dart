import 'api_service.dart';
import 'auth_service.dart';
import '../models/alert.dart';

class AlertsService {
  AlertsService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<Alert>> getAlerts() async {
    final response = await _apiService.get(
      '/alerts/',
      headers: await AuthService.instance.authHeaders(),
    );

    final data = response.data;
    final List<dynamic> alertsList = data is List
        ? data
        : data is Map<String, dynamic>
            ? data['items'] as List<dynamic>? ??
                data['data'] as List<dynamic>? ??
                data['alerts'] as List<dynamic>? ??
                []
            : [];

    return alertsList
        .whereType<Map<String, dynamic>>()
        .map((item) => Alert.fromJson(item))
        .toList();
  }

  Future<Alert> getAlert(String id) async {
    final response = await _apiService.get(
      '/alerts/$id',
      headers: await AuthService.instance.authHeaders(),
    );

    return Alert.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateAlertStatus(String alertId, String status) async {
    await _apiService.patch(
      '/alerts/$alertId/status',
      headers: await AuthService.instance.authHeaders(),
      body: {'status': status},
    );
  }

  Future<Alert> createAlert({
    required String title,
    required String description,
    required String severity,
  }) async {
    final response = await _apiService.post(
      '/alerts/',
      headers: await AuthService.instance.authHeaders(),
      body: {
        'title': title,
        'description': description,
        'severity': severity,
        'status': 'open',
      },
    );

    return Alert.fromJson(response.data as Map<String, dynamic>);
  }

  // حذف تنبيه
  Future<void> deleteAlert(String id) async {
    await _apiService.delete(
      '/alerts/$id',
      headers: await AuthService.instance.authHeaders(),
    );
  }
}