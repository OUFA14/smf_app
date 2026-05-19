import 'api_service.dart';
import 'auth_service.dart';
import '../models/work_info.dart';

class WorkInfoService {
  WorkInfoService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<WorkInfo> getWorkInfo(String userId) async {
    final response = await _apiService.get(
      '/users/$userId/work-info',
      headers: await AuthService.instance.authHeaders(),
    );

    return WorkInfo.fromJson(response.data as Map<String, dynamic>);
  }

  Future<WorkInfo> updateWorkInfo(String userId, WorkInfo workInfo) async {
    final response = await _apiService.put(
      '/users/$userId/work-info',
      headers: await AuthService.instance.authHeaders(),
      body: workInfo.toJson(),
    );

    return WorkInfo.fromJson(response.data as Map<String, dynamic>);
  }
}