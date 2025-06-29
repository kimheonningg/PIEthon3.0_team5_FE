// Timeline 형태의 UI
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:intl/intl.dart';

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

  void _showAddHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddHistoryDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Timeline',
                      style: TextStyle(
                        color: MainColors.sidebarItemText,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.h12,
                    const Text(
                      '42 entries',
                      style: TextStyle(
                        color: MainColors.sidebarNameText,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showAddHistoryDialog,
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text('Add History'),
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

class AddHistoryDialog extends StatefulWidget {
  const AddHistoryDialog({super.key});

  @override
  State<AddHistoryDialog> createState() => _AddHistoryDialogState();
}

class _AddHistoryDialogState extends State<AddHistoryDialog> {
  final _dateTextController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedType = 'Lab Result';
  html.File? _selectedFile;
  bool _isUploading = false;

  final List<String> _historyTypes = ['Lab Result'];

  @override
  void dispose() {
    _dateTextController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateTextController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          setState(() {
            _selectedFile = files[0];
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파일 선택 실패: $e')),
      );
    }
  }

  Future<void> _uploadHistory() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('날짜를 선택해주세요')),
      );
      return;
    }

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일을 선택해주세요')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final token = await TokenManager.getAccessToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다')),
        );
        return;
      }

      // TODO: 실제 환자 MRN을 가져와야 합니다
      const patientMrn = "29303042"; // 임시값

      // HTML File을 Uint8List로 변환
      final reader = html.FileReader();
      reader.readAsArrayBuffer(_selectedFile!);
      await reader.onLoad.first;
      final Uint8List fileBytes = reader.result as Uint8List;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$BASE_URL/labresults/parse_and_create'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['patient_mrn'] = patientMrn;
      request.fields['lab_date'] = _selectedDate!.toIso8601String();

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          fileBytes,
          filename: _selectedFile!.name,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('업로드가 완료되었습니다')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 실패: $responseBody')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MainColors.sidebarBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add History',
                  style: TextStyle(
                    color: MainColors.sidebarItemText,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: MainColors.sidebarItemText),
                ),
              ],
            ),
            Gaps.v20,
            
            // 유형 선택
            const Text(
              '유형',
              style: TextStyle(
                color: MainColors.sidebarItemText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gaps.v8,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: MainColors.textfield,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue!;
                    });
                  },
                  dropdownColor: MainColors.textfield,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: _historyTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            Gaps.v20,

            // 날짜 선택
            const Text(
              '날짜',
              style: TextStyle(
                color: MainColors.sidebarItemText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gaps.v8,
            TextField(
              controller: _dateTextController,
              readOnly: true,
              onTap: _pickDate,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: '날짜 선택 (YYYY-MM-DD)',
                filled: true,
                fillColor: MainColors.textfield,
                hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                suffixIcon: const Icon(Icons.calendar_today, color: MainColors.hinttext),
              ),
            ),
            Gaps.v20,

            // 파일 첨부
            const Text(
              '파일 첨부',
              style: TextStyle(
                color: MainColors.sidebarItemText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gaps.v8,
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MainColors.textfield,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: MainColors.dividerLine,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, color: MainColors.hinttext),
                    Gaps.h12,
                    Expanded(
                      child: Text(
                        _selectedFile?.name ?? '파일을 선택하세요',
                        style: TextStyle(
                          color: _selectedFile != null ? Colors.white : MainColors.hinttext,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gaps.v24,

            // 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: MainColors.sidebarNameText),
                  ),
                ),
                Gaps.h12,
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainColors.sidebarItemSelectedText,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('업로드'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
