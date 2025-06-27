import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/widgets/navigation_sidebar.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNavigationBar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Schedule',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 256,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search appointments...',
                                hintStyle:
                                    const TextStyle(color: MainColors.hinttext),
                                prefixIcon: const Icon(Icons.search,
                                    color: MainColors.hinttext),
                                filled: true,
                                fillColor: MainColors.textfield,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: MainColors.aiEnabled,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('AI System: Online',
                                    style: TextStyle(color: Color(0xFF4B5563))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              // new appointment 화면으로 이동
                            },
                            icon: const Icon(Icons.add,
                                size: 18, color: Colors.white),
                            label: const Text('New Appointment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  MainColors.sidebarItemSelectedText,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(height: 1, color: const Color(0x88374151)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      FilterChip(label: const Text('Day'), onSelected: (_) {}),
                      const SizedBox(width: 8),
                      FilterChip(label: const Text('Week'), onSelected: (_) {}),
                      const SizedBox(width: 8),
                      FilterChip(label: const Text('Month'), onSelected: (_) {}),
                      const SizedBox(width: 32),
                      const Text(
                        'June 25, 2025',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        dropdownColor: Colors.black,
                        value: 'All Physicians',
                        items: const [
                          DropdownMenuItem(
                              value: 'All Physicians',
                              child: Text('All Physicians',
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (_) {},
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        dropdownColor: Colors.black,
                        value: 'All Modalities',
                        items: const [
                          DropdownMenuItem(
                              value: 'All Modalities',
                              child: Text('All Modalities',
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: const Color(0x88374151)),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [ // FIXME: dummy data 교체
                      _TimeBlock(hour: 8, children: [
                        _AppointmentCard('Emily Browning', '8:15 - 9:00 · Brain MRI', Colors.blue),
                      ]),
                      _TimeBlock(hour: 10, children: [
                        _AppointmentCard('Robert Johnson', '10:00 - 10:45 · Spine CT', Colors.green),
                      ]),
                      _TimeBlock(hour: 13, children: [
                        _AppointmentCard('Sophia Liu', '12:30 - 13:00 · Knee X', Colors.amber),
                        _AppointmentCard('Alexander Patel', '13:00 - 13:45 · Chest', Colors.purple),
                      ]),
                      _TimeBlock(hour: 14, children: [
                        _AppointmentCard('Jennifer Martinez', '14:15 - 15:00 · Abdomen', Colors.blue),
                      ]),
                      _TimeBlock(hour: 16, children: [
                        _AppointmentCard('William Smith', '16:00 - 16:45 · Pelvis CT', Colors.green),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final int hour;
  final List<Widget> children;
  const _TimeBlock({required this.hour, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${hour.toString().padLeft(2, '0')}:00',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Gaps.v4,
        ...children,
        Gaps.v16,
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String name;
  final String details;
  final Color color;
  const _AppointmentCard(this.name, this.details, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Gaps.v2,
          Text(details, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
