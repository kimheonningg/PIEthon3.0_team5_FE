import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/widgets/navigation_sidebar.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  List<Map<String, dynamic>> _patientsInfo = [];
  bool _loading = true;

  static const int _pageSize = 8;

  int get _totalPages => // page 개수 동적으로 조절
      (_patientsInfo.length + _pageSize - 1) ~/ _pageSize;

  int _currentPage = 1; // 1페이지부터 보여준다

  List<Map<String, dynamic>> get _pageSlice {
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _patientsInfo.length);
    return _patientsInfo.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => _loading = true); // 새로고침 시 로딩 표시
    try {
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) throw Exception('Please Login.');

      final res = await http.get(
        Uri.parse('$BASE_URL/patients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final raw  = List<Map<String, dynamic>>.from(json['patients']);
        final mapped = raw.map((p) {
          final nameMap = p['name'] as Map<String, dynamic>? ?? {};
          final first   = nameMap['firstName'] ?? '';
          final last    = nameMap['lastName']  ?? '';
          return {
            'name'      : '$last $first', 
            'patientId' : p['patientId'] ?? '',
            'phoneNum'  : p['phoneNum']  ?? '',
            'doctorCnt' : (p['doctorId']      as List).length,
            'noteCnt'   : (p['medicalNotes']  as List).length,
            'createdAt' : p['createdAt'] ?? '',
          };
        }).toList();
        setState(() {
            _patientsInfo = mapped;
            _loading = false;
        });
      } else if (res.statusCode == 401) {
          await TokenManager.clearAccessToken();
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/login');
      } else {
        throw Exception('HTTP ${res.statusCode}');
      }
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Row(
        children: [
          const SideNavigationBar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 헤더
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Patients',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Search Patients
                          SizedBox(
                            width: 256,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search patients...',
                                hintStyle:
                                    const TextStyle(color: MainColors.hinttext),
                                prefixIcon: const Icon(Icons.search,
                                    color: MainColors.hinttext),
                                filled: true,
                                fillColor: MainColors.textfield,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // AI System 상태
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: MainColors.AIenabled,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('AI System: Online',
                                    style: TextStyle(color: Color(0xFF4B5563))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // + New Patient 버튼
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text('New Patient'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  MainColors.sidebarItemSelectedText,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gaps.v24,
                // 2. 필터 및 정렬
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${_patientsInfo.length} patient ${_patientsInfo.length == 1 ? '' : 's'}',
                              style: TextStyle(color: Colors.grey[400])),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: _loadPatients,
                            icon: const Icon(Icons.filter_list, size: 18),
                            label: const Text('Filters'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[300],
                              side: BorderSide(color: Colors.grey[700]!),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.sort, size: 18),
                            label: const Text('Sort'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[300],
                              side: BorderSide(color: Colors.grey[700]!),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Export'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[300],
                              side: BorderSide(color: Colors.grey[700]!),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Refresh'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[300],
                              side: BorderSide(color: Colors.grey[700]!),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gaps.v24,
                // 3. 환자 목록 테이블 (Expanded로 남는 공간을 모두 채움)
                Expanded(
                  child: PatientTable(data: _pageSlice),
                ),
                // 4. 페이지네이션
                Pagination(
                  totalPages: _totalPages,
                  currentPage: _currentPage,
                  onPageSelected: (p) =>
                      setState(() => _currentPage = p),
                  totalItems: _patientsInfo.length,
                  pageSize: _pageSize,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 환자 목록 테이블
class PatientTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const PatientTable({super.key, required this.data});

  // 샘플 데이터
  final List<Map<String, dynamic>> patientData = const [
    {
      'name': 'Emily Browning',
      'gender': 'Female',
      'age': 42,
      'mrn': 'MRN-78542',
      'part': 'Brain',
      'physician': 'Dr. James Wilson',
      'ai_ready': true
    },
    {
      'name': 'Robert Johnson',
      'gender': 'Male',
      'age': 65,
      'mrn': 'MRN-23891',
      'part': 'Spine',
      'physician': 'Dr. Maria Rodriguez',
      'ai_ready': true
    },
    {
      'name': 'Sophia Liu',
      'gender': 'Female',
      'age': 28,
      'mrn': 'MRN-45672',
      'part': 'Knee',
      'physician': 'Dr. Michael Thompson',
      'ai_ready': false
    },
  ];

  @override
  Widget build(BuildContext context) {

    if (data.isEmpty) {
      return const Center(
        child: Text('No assigned patients.',
            style: TextStyle(color: Colors.white)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataTable(
        dataRowColor: WidgetStateProperty.all(const Color(0xFF2D3748)),
        headingRowColor: WidgetStateProperty.all(const Color(0xFF1A202C)),
        headingTextStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        columns: const [
          DataColumn(label: Text(' ')), // 체크박스용
          DataColumn(
              label: Row(children: [
            Text('Name'),
            Icon(Icons.arrow_downward, size: 16)
          ])),
          DataColumn(
              label: Row(children: [
            Text('Age'),
            Icon(Icons.arrow_downward, size: 16)
          ])),
          DataColumn(
              label: Row(children: [
            Text('MRN'),
            Icon(Icons.arrow_downward, size: 16)
          ])),
          DataColumn(
              label: Row(children: [
            Text('Body Part'),
            Icon(Icons.arrow_downward, size: 16)
          ])),
          DataColumn(
              label: Row(children: [
            Text('Physician'),
            Icon(Icons.arrow_downward, size: 16)
          ])),
          DataColumn(label: Text('AI Ready')),
          DataColumn(label: Text(' ')), // 점 3개 메뉴용
        ],
        rows: data.map((p) {
          final initials = p['name']
              .toString()
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((s) => s[0].toUpperCase())
              .join();

          return DataRow(cells: [
            DataCell(Checkbox(
              value: false,
              onChanged: (val) {},
              checkColor: Colors.white,
              activeColor: Colors.blue,
            )),
            DataCell(Row(children: [
              CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(initials,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12))),
              const SizedBox(width: 8),
              Text(p['name'],
                  style: const TextStyle(color: Colors.white)),
            ])),
            DataCell(Text(p['patientId'],
                style: const TextStyle(color: Colors.white))),
            DataCell(Text(p['phoneNum'],
                style: const TextStyle(color: Colors.white))),
            DataCell(Text('${p['doctorCnt']}',
                style: const TextStyle(color: Colors.white))),
            DataCell(Text('${p['noteCnt']}',
                style: const TextStyle(color: Colors.white))),
            DataCell(Text(p['createdAt'].toString().substring(0, 10),
                style: const TextStyle(color: Colors.white))),
            DataCell(IconButton(
                icon:
                    const Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () {})),
          ]);
        }).toList(),
      ),
    );
  }
}

// 하단 페이지 번호들
class Pagination extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final void Function(int) onPageSelected;

  const Pagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageSelected,
    required this.totalItems,
    required this.pageSize,
  });

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 1) * pageSize + 1;
    final end   = (currentPage * pageSize).clamp(1, totalItems);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing $start-$end of $totalItems patient${totalItems == 1 ? '' : 's'}',
          style: TextStyle(color: Colors.grey[400])
        ),
        Row(
          children: [
            TextButton(
              onPressed: currentPage > 1
                ? () => onPageSelected(currentPage - 1)
                : null, child: const Text('< Previous')
            ),
            // 페이지 번호 버튼들
            ...List.generate(totalPages, (i) {
              final pageNum = i + 1;
              return _buildPageButton(
                '$pageNum',
                isSelected: pageNum == currentPage,
                onTap: () => onPageSelected(pageNum),
              );
            }),
            TextButton(
              onPressed: currentPage < totalPages
                  ? () => onPageSelected(currentPage + 1)
                  : null,
              child: const Text('Next >'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(
    String text, {
      bool isSelected = false,
      required VoidCallback onTap,
    }
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF3A65E5) : Colors.transparent,
          foregroundColor: Colors.white,
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text),
      ),
    );
  }
}
