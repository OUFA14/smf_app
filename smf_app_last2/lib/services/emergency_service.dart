import 'api_service.dart';
import 'auth_service.dart';
import '../models/emergency_status.dart';
import '../models/active_incident.dart';
import '../models/incident_feed.dart';
import '../models/emergency_personnel.dart';
import '../models/emergency_contact.dart';
import '../models/system_status.dart';

class EmergencyService {
  EmergencyService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<EmergencyStatus> getStatus() async {
    final response = await _apiService.get(
      '/emergency/status',
      headers: await AuthService.instance.authHeaders(),
    );
    return EmergencyStatus.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ActiveIncident> getActiveIncident() async {
    final response = await _apiService.get(
      '/emergency/active-incident',
      headers: await AuthService.instance.authHeaders(),
    );
    return ActiveIncident.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<IncidentFeedItem>> getIncidentFeed() async {
    final response = await _apiService.get(
      '/emergency/incident-feed',
      headers: await AuthService.instance.authHeaders(),
    );
    final data = response.data;
    final List<dynamic> list = data is List
        ? data
        : data is Map<String, dynamic>
            ? data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? []
            : [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(IncidentFeedItem.fromJson)
        .toList();
  }

  Future<List<EmergencyPersonnel>> getPersonnel() async {
    final response = await _apiService.get(
      '/emergency/personnel',
      headers: await AuthService.instance.authHeaders(),
    );
    final data = response.data;
    final List<dynamic> list = data is List
        ? data
        : data is Map<String, dynamic>
            ? data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? []
            : [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(EmergencyPersonnel.fromJson)
        .toList();
  }

  Future<List<EmergencyContact>> getContacts() async {
    final response = await _apiService.get(
      '/emergency/contacts',
      headers: await AuthService.instance.authHeaders(),
    );
    final data = response.data;
    final List<dynamic> list = data is List
        ? data
        : data is Map<String, dynamic>
            ? data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? []
            : [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(EmergencyContact.fromJson)
        .toList();
  }

  Future<SystemStatus> getSystemStatus() async {
    final response = await _apiService.get(
      '/emergency/system-status',
      headers: await AuthService.instance.authHeaders(),
    );
    return SystemStatus.fromJson(response.data as Map<String, dynamic>);
  }
}
