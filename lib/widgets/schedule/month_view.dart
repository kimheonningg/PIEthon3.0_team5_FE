import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piethon_team5_fe/models/appointment.dart';

class MonthView extends StatelessWidget {
  final DateTime focusedDate;
  final List<Appointment> appointments;

  const MonthView({
    super.key,
    required this.focusedDate,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final daysBefore = firstDayOfMonth.weekday % 7;
    final daysInMonth = DateUtils.getDaysInMonth(focusedDate.year, focusedDate.month);
    final totalDays = daysBefore + daysInMonth;
    final weeks = (totalDays / 7.0).ceil();

    const weekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Weekday header
            Row(
              children: List.generate(7, (index) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: Text(
                      weekDays[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Calendar grid
            ...List.generate(weeks, (weekIndex) {
              return Expanded(
                child: Row(
                  children: List.generate(7, (dayIndex) {
                    final dayOffset = weekIndex * 7 + dayIndex - daysBefore;
                    final day = DateTime(focusedDate.year, focusedDate.month, 1).add(Duration(days: dayOffset));
                    final isInMonth = day.month == focusedDate.month;

                    final dayAppointments = appointments.where((a) =>
                      a.startTime.year == day.year &&
                      a.startTime.month == day.month &&
                      a.startTime.day == day.day).toList();

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isInMonth ? const Color(0xFF1F2937) : const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isInMonth ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...dayAppointments.map((a) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade700,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${DateFormat.Hm().format(a.startTime)} ${a.appointmentDetail}',
                                  style: const TextStyle(fontSize: 10, color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
