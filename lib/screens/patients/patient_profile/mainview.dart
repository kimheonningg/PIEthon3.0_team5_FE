import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/provider/mainview_tab_provider.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_clinical_notes.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_imaging.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_medical_history.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_overview.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview_contents/mainview_treatment_plans.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:provider/provider.dart';

class Mainview extends StatefulWidget {
  final Map<String, dynamic> patientInfo;

  const Mainview({super.key, required this.patientInfo});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> with TickerProviderStateMixin {
  final List<String> _tabs = ['Overview', 'Medical History', 'Imaging', 'Treatment Plans', 'Clinical Notes'];
  // final Map<String, Widget> _tabWidgets = {
  //   'Overview': const MainviewOverview(),
  //   'Medical History': const MainviewMedicalHistory(),
  //   'Imaging': const MainviewImaging(),
  //   'Treatment Plans': const MainviewTreatmentPlans(),
  //   'Clinical Notes': const MainviewClinicalNotes(),
  // };

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patientInfo;

    final rawDob = patient['birthdate'];
    final dobDate = DateTime.tryParse(rawDob ?? '') ?? DateTime(1900);
    final dobFormatted = DateFormat('yyyy-MM-dd').format(dobDate);

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 환자 정보
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${patient['name']}',
                          style: const TextStyle(color: MainColors.sidebarItemText, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                        label: const Text('Edit Patient', style: TextStyle(color: Colors.white, fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: MainColors.button2,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      Gaps.h8,
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_outlined, size: 16, color: MainColors.button2),
                        label: const Text('More', style: TextStyle(color: MainColors.button2, fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                  Gaps.v12,
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 14, color: MainColors.sidebarNameText),
                            Gaps.h4,
                            Text('${patient['age']} years (DOB: $dobFormatted)',
                                style: const TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            Icon(patient['gender'] == 'Female' ? Icons.female : Icons.male,
                                size: 14, color: MainColors.sidebarNameText),
                            Gaps.h4,
                            Text(patient['gender'], style: const TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.assignment_outlined, size: 14, color: MainColors.sidebarNameText),
                            Gaps.h4,
                            Text('MRN: ${patient['mrn']}',
                                style: const TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.v24,
              Expanded(
                child: Consumer<MainviewTabProvider>(builder: (context, provider, child) {
                  _tabController.index = _tabs.indexOf(provider.currentTabName);

                  return DefaultTabController(
                    length: _tabs.length,
                    child: Scaffold(
                      appBar: AppBar(
                        toolbarHeight: 0,
                        backgroundColor: MainColors.background,
                        bottom: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: MainColors.selectedTab,
                          unselectedLabelColor: MainColors.sidebarNameText,
                          indicatorColor: MainColors.selectedTab,
                          tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children:  [
                          MainviewOverview(patientMrn: patient['mrn']),
                          const MainviewMedicalHistory(),
                          const MainviewImaging(),
                          const MainviewTreatmentPlans(),
                          const MainviewClinicalNotes(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const Divider(color: MainColors.dividerLine, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
