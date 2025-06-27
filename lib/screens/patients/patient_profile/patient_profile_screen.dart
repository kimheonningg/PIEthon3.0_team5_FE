// "/profile/patient" 경로
import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/graphview.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/patient_profile_sidebar.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreen();
}

class _PatientProfileScreen extends State<PatientProfileScreen> {
  bool _isMainview = true; //MainView를 보여주는 중인지, GraphView를 보여주는 중인지

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const PatientProfileSidebar(),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // main view / graph view 선택
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isMainview = true;
                              });
                            },
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text('Main View'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: _isMainview
                                  ? MainColors.button2
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isMainview = false;
                              });
                            },
                            icon: const Icon(
                              Icons.bubble_chart_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text('Graph View'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: !_isMainview
                                  ? MainColors.button2
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),

                          const Spacer(),
                          // 사용자 프로필 등 추가 가능
                        ],
                      ),
                    ),
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
                  ],
                ),
              ),
              Container(
                height: 1,
                color: const Color(0x88374151),
              ),
              Expanded(
                  child: _isMainview ? const Mainview() : const GraphView()),
            ],
          ))
        ],
      ),
    );
  }
}
