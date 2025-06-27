import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_clinical_notes.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_imaging.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_medical_history.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_overview.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_treatment_plans.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  final List<String> _tabs = ['Overview', 'Medical History', 'Imaging', 'Treatment Plans', 'Clinical Notes'];
  final Map<String, Widget> _tabWidgets = {
    'Overview': const MainviewOverview(),
    'Medical History': const MainviewMedicalHistory(),
    'Imaging': const MainviewImaging(),
    'Treatment Plans': const MainviewTreatmentPlans(),
    'Clinical Notes': const MainviewClinicalNotes(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //환자 정보
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Emily Browning',
                            style: TextStyle(color: MainColors.sidebarItemText, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Edit Patient',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            backgroundColor: MainColors.button2,
                            padding: const EdgeInsets.all(12)),
                      ),
                      Gaps.h8,
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert_outlined,
                          size: 16,
                          color: MainColors.button2,
                        ),
                        label: const Text(
                          'More',
                          style: TextStyle(color: MainColors.button2, fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(12)),
                      ),
                    ],
                  ),
                  Gaps.v12,
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: MainColors.sidebarNameText,
                            ),
                            Gaps.h4,
                            Text('42 years (DOB: 04/12/1983)', style: TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.female,
                              size: 14,
                              color: MainColors.sidebarNameText,
                            ),
                            Gaps.h4,
                            Text('42 years (DOB: 04/12/1983)', style: TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 14,
                              color: MainColors.sidebarNameText,
                            ),
                            Gaps.h4,
                            Text('MRN: 78942651', style: TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.v24,

              Expanded(
                child: DefaultTabController(
                  length: _tabs.length, // 탭의 총 개수
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: MainColors.background,
                      bottom: TabBar(
                        isScrollable: true, // 각 탭이 내용에 맞는 너비를 갖도록 설정
                        tabAlignment: TabAlignment.start,
                        labelColor: MainColors.selectedTab,
                        unselectedLabelColor: MainColors.sidebarNameText,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                        indicatorColor: MainColors.selectedTab,

                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2.0, color: MainColors.selectedTab),
                        ),

                        tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                      ),
                    ),
                    // TabBar의 각 탭에 해당하는 내용을 보여주는 부분
                    body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: _tabs.map((String name) {
                        return _tabWidgets[name]!;
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const Divider(color: MainColors.dividerLine, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
