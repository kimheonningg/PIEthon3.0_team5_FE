import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/models/medical_history_model.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/create_new_medication_screen.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/screens/schedule/create_schedule_screen.dart';

enum CardType { currentMedications, scheduledProcedures, followUpAppointments, treatmentHistory }

class MainviewTreatmentPlans extends StatefulWidget {
  const MainviewTreatmentPlans({super.key});

  @override
  State<MainviewTreatmentPlans> createState() => _MainviewTreatmentPlansState();
}

class _MainviewTreatmentPlansState extends State<MainviewTreatmentPlans> {
  final List<List<String>> _medications = []; //[0]이 title, [1]이 body

  // Medication 정보 가져오기
  Future<void> _fetchMedications() async {
    try {
      final token = await TokenManager.getAccessToken();
      final response = await http.get(
        Uri.parse('$BASE_URL/medicalhistories/medications/123'), //여기 고치기!!!!
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> medications = json['medical_histories'] ?? [];
        if (medications.isNotEmpty) {
          medications.map((value) {
            MedicalHistoryModel medicalHistory = MedicalHistoryModel.fromJson(value);
            _medications.add([medicalHistory.title, 'Date : ${medicalHistory.date}\n${medicalHistory.content}']);
          });
        }
      } else {
        print('[Medication] Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('[Medication] Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DashboardCard(
              cardType: CardType.currentMedications,
              contents: _medications,
              fetchFunction: () {
                _fetchMedications();
              },
            ),
            Gaps.v20,
            DashboardCard(
              cardType: CardType.scheduledProcedures,
              contents: const [],
              fetchFunction: () {},
            ),
            Gaps.v20,
            DashboardCard(
              cardType: CardType.followUpAppointments,
              contents: const [],
              fetchFunction: () {},
            ),
            Gaps.v20,
            DashboardCard(
              cardType: CardType.treatmentHistory,
              contents: const [],
              fetchFunction: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final CardType cardType;
  final List<List<String>> contents;
  final Function fetchFunction;

  const DashboardCard({
    super.key,
    required this.cardType,
    required this.contents,
    required this.fetchFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: MainColors.dividerLine, width: 1), borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카드 제목 부분
            Container(
              width: double.infinity,
              color: Colors.transparent,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      cardType == CardType.currentMedications
                          ? 'Current Medications'
                          : cardType == CardType.scheduledProcedures
                              ? 'Scheduled Procedures'
                              : cardType == CardType.followUpAppointments
                                  ? 'Follow-up Appointments'
                                  : 'Treatment History',
                      style: const TextStyle(
                        color: MainColors.sidebarItemText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  cardType == CardType.treatmentHistory
                      ? const SizedBox()
                      : ElevatedButton.icon(
                          onPressed: () async {
                            if (cardType == CardType.currentMedications) {
                              await Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const CreateNewMedicationScreen()));
                              await fetchFunction();
                            }
                            if (cardType == CardType.followUpAppointments) {
                              Navigator.pushNamed(context, '/schedule/create');
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(cardType == CardType.currentMedications
                              ? 'Add Medication'
                              : cardType == CardType.scheduledProcedures
                                  ? 'Schedule Procedure'
                                  : 'Schedule Appointment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColors.sidebarItemSelectedText,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            // 카드 내용 부분
            ...contents.map((content) {
              return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: MainColors.sidebarBackground,
                  child: Column(
                    children: [
                      ///////// 예시 데이터 ////////
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.medication_outlined,
                            size: 20,
                            color: MainColors.selectedTab,
                          ),
                          Gaps.h6,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                content[0],
                                style: const TextStyle(
                                  color: MainColors.sidebarItemText,
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Gaps.v6,
                              Text(
                                content[1],
                                style: const TextStyle(
                                  color: MainColors.sidebarNameText,
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      ////////예시 데이터////////
                    ],
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
