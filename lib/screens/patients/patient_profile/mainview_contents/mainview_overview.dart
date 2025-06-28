import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:piethon_team5_fe/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:piethon_team5_fe/models/medication_model.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/models/appointment.dart';

class Examination {
  final String examinationTitle;
  final DateTime examinationDate;
  final String patientMrn;

  Examination({
    required this.examinationTitle,
    required this.examinationDate,
    required this.patientMrn,
  });

  factory Examination.fromJson(Map<String, dynamic> json) {
    return Examination(
      examinationTitle: json['examination_title'] ?? 'No Title',
      examinationDate: DateTime.parse(json['examination_date']),
      patientMrn: json['patient_mrn'] ?? '',
    );
  }
}

class MainviewOverview extends StatefulWidget {
  final String patientMrn;

  const MainviewOverview({super.key, required this.patientMrn});

  @override
  State<MainviewOverview> createState() => _MainviewOverviewState();
}

class _MainviewOverviewState extends State<MainviewOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1500
                ? 3
                : constraints.maxWidth > 700
                    ? 2
                    : 1;
            return StaggeredGrid.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: TreatmentPlanCard(patientMrn: widget.patientMrn),
                ),
                const StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: ImagingCard(
                    isSuccess: true,
                    title: 'Imaging with AI Analysis: T1',
                  ),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: RecentExaminationsCard(patientMrn: widget.patientMrn),
                ),
                const StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: ImagingCard(
                    title: 'Imaging with AI Analysis: T2',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: MainColors.dividerLine, width: 1), borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            Container(padding: const EdgeInsets.all(16), color: MainColors.sidebarBackground, child: child),
          ],
        ),
      ),
    );
  }
}

//////// Treatment Plan
class TreatmentPlanCard extends StatefulWidget {
  final String patientMrn;
  const TreatmentPlanCard({super.key, required this.patientMrn});

  @override
  State<TreatmentPlanCard> createState() => _TreatmentPlanCardState();
}

class _TreatmentPlanCardState extends State<TreatmentPlanCard> {
  Appointment? _nextAppointment;
  List<MedicationModel> _medicationHistories = [];

  @override
  void initState() {
    super.initState();
    _fetchNextAppointment();
    _fetchMedications();
  }

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

  Future<void> _fetchNextAppointment() async {
    try {
      final token = await TokenManager.getAccessToken();
      final response = await http.get(
        Uri.parse('$BASE_URL/appointments/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> appointments = json['appointments'] ?? [];
        if (appointments.isNotEmpty) {
          final latest = Appointment.fromJson(appointments.first);
          setState(() => _nextAppointment = latest);
        }
      } else {
        print('[Appointment] Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('[Appointment] Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Current Treatment Plan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Medications', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          ..._medicationHistories.map((h) => _buildListItem(
                Icons.medication_outlined,
                h.title,
                h.content,
              )),
          if (_medicationHistories.isEmpty)
            const Text(
              'No medication histories found.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          Gaps.v8,
          const Divider(
            color: MainColors.dividerLine,
            height: 1,
          ),
          Gaps.v8,
          _buildSectionTitle('Follow-up'),
          _nextAppointment != null
              ? _buildListItem(
                  Icons.calendar_today_outlined,
                  _nextAppointment!.appointmentDetail,
                  DateFormat('MMMM d, yyyy \'at\' h:mm a').format(_nextAppointment!.startTime),
                )
              : const Text(
                  'No upcoming appointments.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildListItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////// Recent Examination (이 위젯은 이전 답변에서 완성된 상태로, 변경 없음)
class RecentExaminationsCard extends StatefulWidget {
  final String patientMrn;
  const RecentExaminationsCard({super.key, required this.patientMrn});

  @override
  State<RecentExaminationsCard> createState() => _RecentExaminationsCardState();
}

class _RecentExaminationsCardState extends State<RecentExaminationsCard> {
  late Future<List<Examination>> _examinationsFuture;

  @override
  void initState() {
    super.initState();
    _examinationsFuture = _fetchExaminations(widget.patientMrn);
  }

  Future<List<Examination>> _fetchExaminations(String mrn) async {
    final token = await TokenManager.getAccessToken();
    if (token == null) throw Exception('Token not found.');

    final response = await http.get(
      Uri.parse('$BASE_URL/examinations/$mrn'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Examination.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load examinations: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Recent Examinations',
      child: FutureBuilder<List<Examination>>(
        future: _examinationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recent examinations found.'));
          }

          final examinations = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: examinations.length,
            itemBuilder: (context, index) {
              final exam = examinations[index];
              return _buildExaminationItem(
                title: exam.examinationTitle,
                date: DateFormat('MMMM d, yyyy').format(exam.examinationDate),
                isCurrent: index == 0,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 24),
          );
        },
      ),
    );
  }

  Widget _buildExaminationItem({
    required String title,
    required String date,
    bool isCurrent = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            color: isCurrent ? MainColors.sidebarItemSelectedText : MainColors.sidebarNameText,
          ),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Gaps.v4,
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///// Imaging Card (변경 없음)
class ImagingCard extends StatelessWidget {
  final String title;
  final bool isSuccess;

  const ImagingCard({super.key, this.isSuccess = false, required this.title});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: title,
      trailing: const Row(
        children: [
          Icon(
            Icons.check,
            color: Color(0xFF22FF00),
          ),
          Gaps.h2,
          Icon(
            Icons.close,
            color: Colors.red,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽: 이미지 영역
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      // 이미지가 들어갈 부분!!
                      child: const Placeholder(),
                    ),
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Chip(
                        label: Text(
                          'confidence score: 0.89',
                          style: TextStyle(
                            color: MainColors.sidebarItemSelectedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Color(0xEEFFFFFF),
                        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                // 하단 버튼 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      style: const ButtonStyle(
                        iconColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(MainColors.background),
                      ),
                      icon: const Icon(Icons.image_outlined, size: 16),
                      label: const Text(
                        'View All Images',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Row(
                      children: [
                        IconButton(
                            splashRadius: 4,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 16,
                            )),
                        IconButton(
                            splashRadius: 4,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_forward,
                              size: 16,
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Gaps.h16,
          // 오른쪽: 분석 결과 텍스트 영역
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: MainColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Analysis Results', style: TextStyle(fontWeight: FontWeight.bold, color: MainColors.sidebarItemText)),
                  Gaps.v4,
                  Text('A 1.8 cm nodule detected...', style: TextStyle(color: MainColors.sidebarItemText, fontSize: 14)),
                  Gaps.v16,
                  Text('Comparison with Previous Studies',
                      style: TextStyle(fontWeight: FontWeight.bold, color: MainColors.sidebarItemText)),
                  Gaps.v4,
                  Text('Nodule has increased in size...', style: TextStyle(color: MainColors.sidebarItemText, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
