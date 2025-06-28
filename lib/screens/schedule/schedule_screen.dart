import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/widgets/navigation_sidebar.dart';
import 'package:piethon_team5_fe/widgets/schedule/day_view.dart';
import 'package:piethon_team5_fe/widgets/schedule/week_view.dart';
import 'package:piethon_team5_fe/widgets/schedule/month_view.dart';
import 'package:piethon_team5_fe/models/appointment.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

enum ViewType { day, week, month }

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final token = await TokenManager.getAccessToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar( content: Text('Login required. Please sign in again.')),
      );
      return;
    }
    final url = Uri.parse('$BASE_URL/patients/create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
      Uri.parse('$BASE_URL/appointments'),
      headers: headers
    );
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final items = jsonBody['appointments'] as List;
      setState(() {
        _appointments = items.map((e) => Appointment.fromJson(e)).toList();
      });
    } else {
      print('Failed to load appointments');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  ViewType _currentView = ViewType.day;
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.background,
      body: Row(
        children: [
          const SideNavigationBar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(height: 1, color: Color(0x88374151)),
                _buildSubHeader(),
                Expanded(child: _buildCurrentView()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              Container(
                width: 240,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF374151)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white30, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Search appointments...',
                          hintStyle: TextStyle(color: Colors.white30),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              const Icon(Icons.circle, color: Color(0xFF22C55E), size: 10),
              const SizedBox(width: 6),
              const Text(
                'AI System: Online',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(width: 16),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/schedule/create');
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A65E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildViewToggle(ViewType.day, 'Day'),
              const SizedBox(width: 8),
              _buildViewToggle(ViewType.week, 'Week'),
              const SizedBox(width: 8),
              _buildViewToggle(ViewType.month, 'Month'),
              const SizedBox(width: 16),

              IconButton(
                onPressed: () {
                  setState(() {
                    _currentDate = _currentDate.subtract(const Duration(days: 1));
                  });
                },
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentDate = DateTime.now();
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('Today'),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentDate = _currentDate.add(const Duration(days: 1));
                  });
                },
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat.yMMMMd().format(_currentDate),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),

          Row(
            children: [
              DropdownButton<String>(
                value: 'All Physicians',
                onChanged: (value) {},
                dropdownColor: const Color(0xFF1F2937),
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 'All Physicians', child: Text('All Physicians')),
                  DropdownMenuItem(value: 'Dr. Lee', child: Text('Dr. Lee')),
                  DropdownMenuItem(value: 'Dr. Kim', child: Text('Dr. Kim')),
                ],
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: 'All Modalities',
                onChanged: (value) {},
                dropdownColor: const Color(0xFF1F2937),
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 'All Modalities', child: Text('All Modalities')),
                  DropdownMenuItem(value: 'MRI', child: Text('MRI')),
                  DropdownMenuItem(value: 'CT', child: Text('CT')),
                  DropdownMenuItem(value: 'XRAY', child: Text('X-RAY')),
                  DropdownMenuItem(value: 'ULTRASOUND', child: Text('ULTRASOUND')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildViewToggle(ViewType view, String label) {
    final selected = _currentView == view;
    return ElevatedButton(
      onPressed: () => setState(() => _currentView = view),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFF3A65E5) : Colors.transparent,
        foregroundColor: Colors.white,
        side: selected ? BorderSide.none : const BorderSide(color: Color(0xFF4B5563)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case ViewType.day:
        return DayView(appointments: _appointments);
      case ViewType.week:
        return WeekView(appointments: _appointments, currentDate: _currentDate);
      case ViewType.month:
        return MonthView(appointments: _appointments, focusedDate: _currentDate);
    }
  }
}
