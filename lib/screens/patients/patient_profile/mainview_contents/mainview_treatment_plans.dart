import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DashboardCard(cardType: CardType.currentMedications),
            Gaps.v20,
            DashboardCard(cardType: CardType.scheduledProcedures),
            Gaps.v20,
            DashboardCard(cardType: CardType.followUpAppointments),
            Gaps.v20,
            DashboardCard(cardType: CardType.treatmentHistory),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final CardType cardType;

  const DashboardCard({
    super.key,
    required this.cardType,
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
                          onPressed: () {
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
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: MainColors.sidebarBackground,
                child: const Column(
                  children: [
                    ///////// 예시 데이터 ////////
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 20,
                          color: MainColors.selectedTab,
                        ),
                        Gaps.h6,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Awesome Title~',
                              style: TextStyle(
                                color: MainColors.sidebarItemText,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gaps.v6,
                            Text(
                              'Good Contents\nGood Contents\nAwesome Contents~~~~',
                              style: TextStyle(
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
                )),
          ],
        ),
      ),
    );
  }
}
