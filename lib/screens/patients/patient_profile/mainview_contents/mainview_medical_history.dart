// Timeline 형태의 UI
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:timelines_plus/timelines_plus.dart';

enum HistoryType { condition, medication, imaging, labResult, surgery, clinicalNotes }

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
      tags: ['Monitoring'],
      historyType: HistoryType.condition,
    ),
    TimelineEvent(
        date: 'June 20, 2025',
        title: 'Prescription Update',
        description: 'Prescribed Lisinopril 10mg daily for blood pressure management. Review in 3 months.',
        tags: ['New Prescription'],
        historyType: HistoryType.medication),
    TimelineEvent(
        date: 'June 14, 2025',
        title: 'Chest MRI',
        description: 'MRI revealed a 1.8 cm nodule in the right upper lobe. Follow-up recommended in 3 months.',
        tags: ['Follow-up Required'],
        historyType: HistoryType.imaging),
    TimelineEvent(
        date: 'June 14, 2025',
        title: 'Blood Work Results',
        description: 'Complete blood count and metabolic panel completed. Elevated white blood cell count noted.',
        tags: ['Abnormal'],
        historyType: HistoryType.labResult),
    TimelineEvent(
        date: 'May 15, 2025',
        title: 'Appendectomy',
        description: 'Laparoscopic appendectomy performed. No complications. Recovery progressing well.',
        tags: ['Completed'],
        historyType: HistoryType.surgery),
    TimelineEvent(
        date: 'May 2, 2025',
        title: 'Chest CT Scan',
        description: 'CT scan showed a 1.4 cm nodule in the right upper lobe. Additional imaging recommended.',
        tags: ['Follow-up Required'],
        historyType: HistoryType.clinicalNotes),
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
                  color: event.historyType == HistoryType.condition
                      ? const Color(0xFF7F1D1D)
                      : event.historyType == HistoryType.medication
                          ? const Color(0xFF881337)
                          : event.historyType == HistoryType.imaging
                              ? const Color(0xFF713F12)
                              : event.historyType == HistoryType.labResult
                                  ? const Color(0xFF581C87)
                                  : event.historyType == HistoryType.surgery
                                      ? const Color(0xFF14532D)
                                      : const Color(0xFF01276D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                    event.historyType == HistoryType.condition
                        ? Symbols.cardiology
                        : event.historyType == HistoryType.medication
                            ? Icons.medication_outlined
                            : event.historyType == HistoryType.imaging
                                ? Icons.image_outlined
                                : event.historyType == HistoryType.labResult
                                    ? Icons.biotech_outlined
                                    : event.historyType == HistoryType.surgery
                                        ? Icons.masks_outlined
                                        : Symbols.docs,
                    color: event.historyType == HistoryType.condition
                        ? const Color(0xFFEF4444)
                        : event.historyType == HistoryType.medication
                            ? const Color(0xFFF43F5E)
                            : event.historyType == HistoryType.imaging
                                ? const Color(0xFFEAB308)
                                : event.historyType == HistoryType.labResult
                                    ? const Color(0xFFA855F7)
                                    : event.historyType == HistoryType.surgery
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFF1767F9),
                    size: 24),
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
            children: [
              Container(
                decoration: BoxDecoration(
                    color: event.historyType == HistoryType.condition
                        ? const Color(0xFF7F1D1D)
                        : event.historyType == HistoryType.medication
                            ? const Color(0xFF881337)
                            : event.historyType == HistoryType.imaging
                                ? const Color(0xFF713F12)
                                : event.historyType == HistoryType.labResult
                                    ? const Color(0xFF581C87)
                                    : event.historyType == HistoryType.surgery
                                        ? const Color(0xFF14532D)
                                        : const Color(0xFF01276D),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                    event.historyType == HistoryType.condition
                        ? 'Condition'
                        : event.historyType == HistoryType.medication
                            ? 'Medication'
                            : event.historyType == HistoryType.imaging
                                ? 'Imaging'
                                : event.historyType == HistoryType.labResult
                                    ? 'Lab Result'
                                    : event.historyType == HistoryType.surgery
                                        ? 'Surgery'
                                        : 'Clinical Notes',
                    style: TextStyle(
                        color: event.historyType == HistoryType.condition
                            ? const Color(0xFFEF4444)
                            : event.historyType == HistoryType.medication
                                ? const Color(0xFFF43F5E)
                                : event.historyType == HistoryType.imaging
                                    ? const Color(0xFFEAB308)
                                    : event.historyType == HistoryType.labResult
                                        ? const Color(0xFFA855F7)
                                        : event.historyType == HistoryType.surgery
                                            ? const Color(0xFF22C55E)
                                            : const Color(0xFF1767F9),
                        fontSize: 12)),
              ),
              ...event.tags.map((tag) {
                return Container(
                  decoration: BoxDecoration(color: MainColors.dividerLine, borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(tag, style: const TextStyle(color: MainColors.sidebarItemText, fontSize: 12)),
                );
              })
            ],
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
  final List<String> tags;
  final HistoryType historyType;

  TimelineEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.tags,
    required this.historyType,
  });
}
