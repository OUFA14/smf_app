import 'api_service.dart';
import 'auth_service.dart';
import '../models/dashboard_metrics.dart';

class DashboardService {
  DashboardService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<DashboardMetrics> getMetrics() async {
    final response = await _apiService.get(
      '/dashboard/metrics',
      headers: await AuthService.instance.authHeaders(),
    );

    final data = response.data as Map<String, dynamic>;
    return DashboardMetrics.fromJson(data);
  }
}