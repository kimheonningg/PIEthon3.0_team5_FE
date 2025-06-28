import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/models/medication_model.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/create_new_medication_screen.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/screens/schedule/create_schedule_screen.dart';

enum CardType { currentMedications, scheduledProcedures, followUpAppointments, treatmentHistory }

class MainviewTreatmentPlans extends StatefulWidget {
  final String patientMrn;

  const MainviewTreatmentPlans({super.key, required this.patientMrn});

  @override
  State<MainviewTreatmentPlans> createState() => _MainviewTreatmentPlansState();
}

class _MainviewTreatmentPlansState extends State<MainviewTreatmentPlans> {
  List<MedicationModel> _medicationHistories = [];

  // Medication 정보 가져오기
  Future<void> _fetchMedications() async {
    try {
      final token = await TokenManager.getAccessToken();
      final response = await http.get(
        Uri.parse('$BASE_URL/medicalhistories/medications/${widget.patientMrn}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        if (body['success'] == true) {
          final List<dynamic> histories = body['medical_histories'];
          setState(() {
            _medicationHistories = histories.map((e) => MedicationModel.fromJson(e)).toList();
          });
        }
      } else {
        print('[Medications] Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('[Medications] Error: $e');
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
              patientMrn: widget.patientMrn,
              contents: _medicationHistories.map((medication) {
                return [medication.title, medication.content];
              }).toList(),
            ),
            Gaps.v20,
            DashboardCard(
              cardType: CardType.scheduledProcedures,
              patientMrn: widget.patientMrn,
              contents: const [],
            ),
            Gaps.v20,
            DashboardCard(
              cardType: CardType.followUpAppointments,
              patientMrn: widget.patientMrn,
              contents: const [],
            ),
            Gaps.v20,
            DashboardCard(
              cardType: CardType.treatmentHistory,
              patientMrn: widget.patientMrn,
              contents: const [],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final CardType cardType;
  final String patientMrn;
  final List<List<String>> contents;

  const DashboardCard({super.key, required this.cardType, required this.patientMrn, required this.contents});

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
                            }
                            if (cardType == CardType.followUpAppointments) {
                              Navigator.pushNamed(context, '/schedule/create');
                            }
                            if (cardType == CardType.currentMedications) {
                              Navigator.pushNamed(context, '/medication/create/$patientMrn');
                            }
                            if (cardType == CardType.scheduledProcedures) {
                              Navigator.pushNamed(context, '/procedure/create/$patientMrn');
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
