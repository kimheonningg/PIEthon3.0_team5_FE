import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PatientInfoManager {
  static const _kPatientsKey = 'patientsInfo';
  static final _storage = const FlutterSecureStorage();

  static Map<String, dynamic>? _selectedPatient;

  static Future<void> saveAll(List<Map<String, dynamic>> patients) async {
    await _storage.write(key: _kPatientsKey, value: jsonEncode(patients));
  }

  static Future<void> addOrUpdate(Map<String, dynamic> patient) async {
    final all = await loadAll() ?? [];
    final mrn = patient['mrn'] as String?;
    if (mrn == null) return;

    final idx = all.indexWhere((p) => p['mrn'] == mrn);
    if (idx >= 0) {
      all[idx] = patient;
    } else {
      all.add(patient);
    }
    await saveAll(all);
  }

  static Future<List<Map<String, dynamic>>?> loadAll() async {
    final raw = await _storage.read(key: _kPatientsKey);
    if (raw == null) return null;

    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map>() 
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return null;
  }

  static Future<Map<String, dynamic>?> loadByMrn(String mrn) async {
    final list = await loadAll();
    if (list == null) return null;
    return list.firstWhere(
      (p) => p['mrn'] == mrn,
      orElse: () => {},
    );
  }

  static Future<void> clear() => _storage.delete(key: _kPatientsKey);

  static void setSelectedPatient(Map<String, dynamic> patient) {
    _selectedPatient = patient;
  }

  static Map<String, dynamic>? getSelectedPatient() {
    return _selectedPatient;
  }
}
