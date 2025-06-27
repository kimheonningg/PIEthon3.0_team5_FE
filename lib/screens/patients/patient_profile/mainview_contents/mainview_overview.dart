import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class MainviewOverview extends StatefulWidget {
  const MainviewOverview({super.key});

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
            // 너비에 맞춰서 한 열에 표시할 카드 개수 정하기
            final crossAxisCount = constraints.maxWidth > 1500
                ? 3
                : constraints.maxWidth > 700
                    ? 2
                    : 1;
            return StaggeredGrid.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: TreatmentPlanCard(),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: ImagingCard(
                    isSuccess: true,
                    title: 'Imaging with AI Analysis: T1',
                  ),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: RecentExaminationsCard(),
                ),
                StaggeredGridTile.fit(
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

// 각 카드들의 부모 위젯
class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing; // 카드 제목 오른쪽에 들어갈 위젯 (아이콘 등)

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
            // 카드 제목 부분
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
            // 카드 내용 부분
            Container(padding: const EdgeInsets.all(16), color: MainColors.sidebarBackground, child: child),
          ],
        ),
      ),
    );
  }
}

//////// Treatment Plan
class TreatmentPlanCard extends StatelessWidget {
  const TreatmentPlanCard({super.key});

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
          _buildListItem(Icons.medication_outlined, 'Albuterol Inhaler', '2 puffs every 4-6 hours as needed'),
          _buildListItem(Icons.medication_outlined, 'Fluticasone Propionate', '2 puffs twice daily'),
          _buildListItem(Icons.medication_outlined, 'Montelukast', '10mg once daily at bedtime'),
          Gaps.v8,
          const Divider(
            color: MainColors.dividerLine,
            height: 1,
          ),
          Gaps.v8,
          _buildSectionTitle('Follow-up'),
          _buildListItem(Icons.calendar_today_outlined, 'Pulmonology Appointment', 'July 10, 2025 at 2:30 PM'),
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

////// Recent Examination
class RecentExaminationsCard extends StatelessWidget {
  const RecentExaminationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Recent Examinations',
      child: Column(
        children: [
          _buildExaminationItem(title: 'Chest MRI', date: 'June 14, 2025', doctor: 'Dr. James Wilson', isCurrent: true),
          const SizedBox(height: 24),
          _buildExaminationItem(
            title: 'Complete Blood Count',
            date: 'June 14, 2025',
            doctor: 'Dr. Patricia Chen',
          ),
          const SizedBox(height: 24),
          _buildExaminationItem(
            title: 'Chest CT',
            date: 'May 2, 2025',
            doctor: 'Dr. James Wilson',
          ),
          const SizedBox(height: 24),
          _buildExaminationItem(
            title: 'Pulmonary Function Test',
            date: 'March 18, 2025',
            doctor: 'Dr. Robert Johnson',
          ),
        ],
      ),
    );
  }

  Widget _buildExaminationItem({
    required String title,
    required String date,
    required String doctor,
    bool isCurrent = false,
  }) {
    // IntrinsicHeight: 자식들이 가진 고유의 높이만큼만 차지하도록 하여,
    // Row 내부의 위젯들이 모두 같은 높이를 갖게 만듭니다.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 왼쪽의 세로 막대
          Container(
            width: 4,
            color: isCurrent ? MainColors.sidebarItemSelectedText : MainColors.sidebarNameText,
          ),
          Gaps.h12,
          // 오른쪽의 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Gaps.v8,
                Row(
                  children: [
                    Icon(Icons.person_outline,
                        color: isCurrent ? MainColors.sidebarItemSelectedText : Colors.grey[400], size: 14),
                    Gaps.h4,
                    Text(
                      doctor,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//////////////

///// Imaging Card
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
