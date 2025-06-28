// Timeline 형태의 UI
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:timelines_plus/timelines_plus.dart';

class MainviewMedicalHistory extends StatefulWidget {
  const MainviewMedicalHistory({super.key});

  @override
  State<MainviewMedicalHistory> createState() => _MainviewMedicalHistoryState();
}

class _MainviewMedicalHistoryState extends State<MainviewMedicalHistory> {
  final List<TimelineEvent> events = [
    TimelineEvent(
      date: 'June 27, 2025',
      title: 'Hypertension Assessment',
      description: 'Blood pressure: 140/90 mmHg. Diagnosed with Stage 1 Hypertension. Regular monitoring required.',
      icon: Symbols.cardiology,
      iconBackgroundColor: const Color(0xFF7F1D1D),
      tags: ['Condition', 'Monitoring'],
      iconTextColor: const Color(0xFFEF4444),
    ),
    TimelineEvent(
      date: 'June 20, 2025',
      title: 'Prescription Update',
      description: 'Prescribed Lisinopril 10mg daily for blood pressure management. Review in 3 months.',
      icon: Icons.medication_outlined,
      tags: ['Medication', 'New Prescription'],
      iconTextColor: const Color(0xFFF43F5E),
      iconBackgroundColor: const Color(0xFF881337),
    ),
    TimelineEvent(
      date: 'June 14, 2025',
      title: 'Chest MRI',
      description: 'MRI revealed a 1.8 cm nodule in the right upper lobe. Follow-up recommended in 3 months.',
      icon: Icons.image_outlined,
      iconBackgroundColor: const Color(0xFF713F12),
      tags: ['Imaging', 'Follow-up Required'],
      iconTextColor: const Color(0xFFEAB308),
    ),
    TimelineEvent(
      date: 'June 14, 2025',
      title: 'Blood Work Results',
      description: 'Complete blood count and metabolic panel completed. Elevated white blood cell count noted.',
      icon: Icons.biotech_outlined,
      iconBackgroundColor: const Color(0xFF581C87),
      iconTextColor: const Color(0xFFA855F7),
      tags: ['Lab Result', 'Abnormal'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Timeline',
                  style: TextStyle(
                    color: MainColors.sidebarItemText,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.h12,
                Text(
                  '42 entries',
                  style: TextStyle(
                    color: MainColors.sidebarNameText,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            Gaps.v30,
            Expanded(
              child: Timeline.tileBuilder(
                theme: TimelineThemeData(
                  color: MainColors.selectedTab,
                  connectorTheme: const ConnectorThemeData(
                    color: MainColors.sidebarNameText,
                    thickness: 1.5,
                  ),
                  indicatorTheme: const IndicatorThemeData(size: 12.0, position: 0),
                ),
                builder: TimelineTileBuilder.fromStyle(
                  contentsAlign: ContentsAlign.basic,
                  nodePositionBuilder: (context, index) => 0,
                  contentsBuilder: (context, index) {
                    final event = events[index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      child: _buildTimelineCard(event),
                    );
                  },
                  itemCount: events.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(TimelineEvent event) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: MainColors.sidebarBackground,
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.all(color: MainColors.dividerLine)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘, 제목, 더보기 버튼
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: event.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(event.icon, color: event.iconTextColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.date, style: const TextStyle(color: MainColors.sidebarNameText, fontSize: 12)),
                    Text(event.title,
                        style: const TextStyle(color: MainColors.sidebarItemText, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: MainColors.sidebarNameText),
              ),
            ],
          ),
          Gaps.v8,
          // 설명
          Text(
            event.description,
            style: const TextStyle(color: MainColors.sidebarNameText, height: 1.4),
          ),
          Gaps.v8,
          // 태그들
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: event.tags.map((tag) {
              final bool isFirst = (event.tags.indexOf(tag) == 0); //첫 번째 태그만 다른 색깔로
              return Container(
                decoration: BoxDecoration(
                    color: isFirst ? event.iconBackgroundColor : MainColors.dividerLine, borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child:
                    Text(tag, style: TextStyle(color: isFirst ? event.iconTextColor : MainColors.sidebarItemText, fontSize: 12)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Timeline event 하나에 해당하는 클래스
class TimelineEvent {
  final String date;
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconTextColor;
  final List<String> tags;

  TimelineEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconTextColor,
    required this.tags,
  });
}
