import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piethon_team5_fe/models/appointment.dart';

class WeekView extends StatelessWidget {
  final DateTime currentDate;
  final List<Appointment> appointments;

  const WeekView({
    super.key,
    required this.currentDate,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final weekStart = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    return Expanded(
      child: Column(
        children: [
          _buildDayLabels(days),
          Expanded(
            child: Row(
              children: days.map((day) => _buildDayColumn(day)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabels(List<DateTime> days) {
    return Row(
      children: days.map((day) {
        final label = DateFormat.E().format(day);
        final number = DateFormat.d().format(day);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(number, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayColumn(DateTime day) {
    final dayAppointments = appointments.where((a) {
      return a.startTime.year == day.year &&
             a.startTime.month == day.month &&
             a.startTime.day == day.day;
    }).toList();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: dayAppointments.map((appt) => _buildAppointmentBox(appt)).toList(),
        ),
      ),
    );
  }

  Widget _buildAppointmentBox(Appointment appt) {
    final start = appt.startTime;
    final end = appt.finishTime;
    final timeRange = '${DateFormat.Hm().format(start)} - ${DateFormat.Hm().format(end)}';
    final detail = appt.appointmentDetail;
    final name = appt.patientName;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(timeRange, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 2),
          Text(detail, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
