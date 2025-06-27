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
      print('jsonBody');
      print(jsonBody);
      setState(() {
        _appointments = items.map((e) => Appointment.fromJson(e)).toList();
      });
    } else {
      print('Failed to load appointments');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  ViewType _currentView = ViewType.month;
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
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
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Schedule',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              _buildViewToggle(ViewType.day, 'Day'),
              const SizedBox(width: 8),
              _buildViewToggle(ViewType.week, 'Week'),
              const SizedBox(width: 8),
              _buildViewToggle(ViewType.month, 'Month'),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  DateFormat.yMMMMd().format(_currentDate),
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A65E5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('+ New Appointment'),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Text('All Physicians'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text('All Modalities'),
              )
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print),
                label: const Text('Print Schedule'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Export'),
              )
            ],
          )
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
