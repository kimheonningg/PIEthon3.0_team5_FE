import 'package:flutter/material.dart';

class Appointment {
  final String patientName;
  final String appointmentDetail;
  final DateTime startTime;
  final DateTime finishTime;
  final Color color;

  Appointment({
    required this.patientName,
    required this.appointmentDetail,
    required this.startTime,
    required this.finishTime,
    required this.color,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'] ?? {};
    final name = '${patient['first_name'] ?? ''} ${patient['last_name'] ?? ''}'.trim();

    return Appointment(
      patientName: name,
      appointmentDetail: json['appointment_detail'] ?? '-',
      startTime: DateTime.parse(json['start_time']),
      finishTime: DateTime.parse(json['finish_time']),
      color: _getColorForModality(json['appointment_detail']),
    );
  }

  static Color _getColorForModality(String detail) {
    final lower = detail.toLowerCase();
    if (lower.contains('mri')) return Colors.indigo;
    if (lower.contains('ct')) return Colors.teal;
    if (lower.contains('x-ray')) return Colors.amber;
    if (lower.contains('ultrasound')) return Colors.deepPurple;
    return Colors.grey;
  }
}
