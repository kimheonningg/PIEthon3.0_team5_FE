import 'package:flutter/material.dart';

//자주 사용되는 색 정의
class MainColors {
  // 이름 수정은 언제나 환영입니다!
  static const background = Color(0xFF171A1C);
  static const textfield = Color(0xFF333638);
  static const hinttext = Color(0xFFABADB0);
  static const button = Color(0xFF212629);
  static const button2 = Color(0xFF1F2937);
  static const sidebarBackground = Color(0xFF2B2D30);
  static const sidebarNameText = Color(0xFF9CA3AF);
  static const sidebarItemText = Color(0xFFD1D5DB);
  static const sidebarItemSelectedText = Color(0xFF3B82F6);
  static const sidebarItemSelectedBackground = Color(0x333B82F6);
  static const aiEnabled = Color(0xFF22C55E);
  static const userProfile = Color(0xFF4B5563);
  static const dividerLine = Color(0xFF374151);
  static const selectedTab = Color(0xFF1767F9);
  // schedule 탭에서 진료 항목별 색깔
  static final mriAppointment = Colors.blue.shade700; // mri
  static final ctAppointment = Colors.green.shade700; // ct
  static final xRayAppointment = Colors.amber.shade700; // x-ray
  static final ultrasoundAppointment = Colors.purple.shade700; // ultrasound
  static final defaultAppointment = Colors.grey.shade700; // 기타
}
