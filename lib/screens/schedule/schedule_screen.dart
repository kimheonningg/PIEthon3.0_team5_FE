import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/navigation_sidebar.dart';
// import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          SideNavigationBar(), // 사이드바
          Expanded(
            child: Center(
              child: Text("Schedule Content Goes Here"),
            ),
          ),
        ],
      ),
    );
  }
}
