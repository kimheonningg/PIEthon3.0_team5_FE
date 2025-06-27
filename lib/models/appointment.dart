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
}