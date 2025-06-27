import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/models/appointment.dart';

class DayView extends StatelessWidget {
  final List<Appointment> appointments;

  const DayView({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 헤더
            Text(
              DateFormat('EEEE, MMMM d').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // 타임라인 뷰
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appt = appointments[index];
                  final start = DateFormat.Hm().format(appt.startTime);
                  final end = DateFormat.Hm().format(appt.finishTime);
                  final name = appt.patientName;
                  final detail = appt.appointmentDetail;
                  final color = _colorByDetail(detail);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$start - $end',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                        Text(
                          name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        Text(detail,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 진료 항목별 색상 매핑
  Color _colorByDetail(String detail) {
    final lower = detail.toLowerCase();
    if (lower.contains('mri')) return MainColors.mriAppointment;
    if (lower.contains('ct')) return MainColors.ctAppointment;
    if (lower.contains('x-ray') || lower.contains('xray')) return MainColors.xRayAppointment;
    if (lower.contains('ultrasound')) return MainColors.ultrasoundAppointment;
    return MainColors.defaultAppointment;
  }
}
