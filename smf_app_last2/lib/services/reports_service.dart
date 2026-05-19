import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'api_service.dart';
import 'auth_service.dart';
import '../models/report_metrics.dart';
import '../models/recent_report.dart';

class ReportsService {
  ReportsService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<ReportMetrics> getMetrics() async {
    final response = await _apiService.get(
      '/reports/metrics',
      headers: await AuthService.instance.authHeaders(),
    );

    return ReportMetrics.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<RecentReport>> getRecentReports() async {
    final response = await _apiService.get(
      '/reports/recent',
      headers: await AuthService.instance.authHeaders(),
    );

    final data = response.data;
    final List<dynamic> list = data is List
        ? data
        : data is Map<String, dynamic>
            ? data['items'] as List<dynamic>? ??
                data['data'] as List<dynamic>? ??
                data['reports'] as List<dynamic>? ??
                []
            : [];

    return list
        .whereType<Map<String, dynamic>>()
        .map((item) => RecentReport.fromJson(item))
        .toList();
  }

  Future<RecentReport> generateReport(String type) async {
    final response = await _apiService.post(
      '/reports/generate',
      headers: await AuthService.instance.authHeaders(),
      body: {'type': type},
    );

    return RecentReport.fromJson(response.data as Map<String, dynamic>);
  }

  Future<File> downloadReport(String reportId, String fileName) async {
    final response = await _apiService.get(
      '/reports/download/$reportId',
      headers: await AuthService.instance.authHeaders(),
    );

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(response.data as List<int>);
    return file;
  }
}