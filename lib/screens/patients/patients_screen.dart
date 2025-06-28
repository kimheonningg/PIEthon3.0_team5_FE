import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/widgets/navigation_sidebar.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/functions/patient_info_manager.dart';
import 'package:piethon_team5_fe/screens/patients/create_new_patient_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  List<Map<String, dynamic>> _patientsInfo = [];
  bool _loading = true;

  // 검색 기능용
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const int _pageSize = 8;

  int _currentPage = 1; // 1페이지부터 보여준다

  // 검색은 이름, MRN, 전화번호로
  List<Map<String, dynamic>> get _filteredPatients {
    if (_searchQuery.isEmpty) return _patientsInfo;
    return _patientsInfo.where((p) {
      final query = _searchQuery.toLowerCase();
      return p['name'].toLowerCase().contains(query) ||
          p['mrn'].toLowerCase().contains(query) ||
          p['phone_num'].toLowerCase().contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _pageSlice {
    final filtered = _filteredPatients;
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, filtered.length);
    if (start >= filtered.length) return [];
    return filtered.sublist(start, end);
  }

  int get _totalPages => (_filteredPatients.length + _pageSize - 1) ~/ _pageSize;

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
        final raw = List<Map<String, dynamic>>.from(json['patients']);
        final mapped = raw.map((p) {
          final nameMap = p['name'] as Map<String, dynamic>? ?? {};
          final first = nameMap['first_name'] ?? '';
          final last = nameMap['last_name'] ?? '';
          return {
            'name': '$last $first',
            'mrn': p['patient_mrn'] ?? '',
            'phone_num': p['phone_num'] ?? '',
            'age': p['age'] ?? '',
            'birthdate': p['birthdate'],
            'doctor_name': p['doctor_name'],
            'body_part': p['body_part'],
            'gender': p['gender'],
            'ai_ready': p['ai_ready'] ?? true,
          };
        }).toList();

        await PatientInfoManager.saveAll(mapped);

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Search Patients
                              SizedBox(
                                width: 256,
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                      _currentPage = 1; // 검색 시 첫 페이지로 이동
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search patients...',
                                    hintStyle: const TextStyle(color: MainColors.hinttext),
                                    prefixIcon: const Icon(Icons.search, color: MainColors.hinttext),
                                    filled: true,
                                    fillColor: MainColors.textfield,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // AI System 상태
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: MainColors.aiEnabled,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('AI System: Online', style: TextStyle(color: Color(0xFF4B5563))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // + New Patient 버튼
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const CreateNewPatientScreen()),
                                  );

                                  setState(() {
                                    _loadPatients();
                                  });
                                },
                                icon: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text('New Patient'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MainColors.sidebarItemSelectedText,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //구분선
                Container(
                  height: 1,
                  color: const Color(0x88374151),
                ),
                // 필터, 정렬 등 버튼들
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text('${_patientsInfo.length} patient${_patientsInfo.length == 1 ? '' : 's'}',
                                  style: TextStyle(color: Colors.grey[400])),
                              const SizedBox(width: 16),
                              OutlinedButton.icon(
                                onPressed: _loadPatients,
                                icon: const Icon(Icons.filter_list, size: 18),
                                label: const Text('Filters'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: MainColors.sidebarItemText,
                                  backgroundColor: MainColors.button2,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.sort, size: 18),
                                label: const Text('Sort'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: MainColors.sidebarItemText,
                                  backgroundColor: MainColors.button2,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Export'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: MainColors.sidebarItemText,
                              backgroundColor: MainColors.button2,
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Refresh'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: MainColors.sidebarItemText,
                              backgroundColor: MainColors.button2,
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //구분선
                Container(
                  height: 1,
                  color: const Color(0x88374151),
                ),

                Gaps.v24,
                // 환자 목록 테이블 (Expanded로 남는 공간을 모두 채움)
                Expanded(
                  child: PatientTable(data: _pageSlice),
                ),
                // 4. 페이지네이션
                Pagination(
                  totalPages: _totalPages,
                  currentPage: _currentPage,
                  onPageSelected: (p) => setState(() => _currentPage = p),
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

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No assigned patients.', style: TextStyle(color: Colors.white)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          dataRowColor: WidgetStateProperty.all(Colors.transparent),
          headingRowColor: WidgetStateProperty.all(Colors.transparent),
          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          columns: const [
            DataColumn(label: Text(' ')), // 체크박스용
            DataColumn(label: Row(children: [Text('Name'), Icon(Icons.arrow_downward, size: 16)])),
            DataColumn(label: Row(children: [Text('Age'), Icon(Icons.arrow_downward, size: 16)])),
            DataColumn(label: Row(children: [Text('MRN'), Icon(Icons.arrow_downward, size: 16)])),
            DataColumn(label: Row(children: [Text('Body Part'), Icon(Icons.arrow_downward, size: 16)])),
            DataColumn(label: Row(children: [Text('Physician'), Icon(Icons.arrow_downward, size: 16)])),
            DataColumn(label: Text('AI Ready')),
            DataColumn(label: Text(' ')), // 점 3개 메뉴용
          ],
          rows: data.map((p) {
            final initials = p['name'].toString().trim().split(RegExp(r'\s+')).take(2).map((s) => s[0].toUpperCase()).join();
            final bodyPartRaw = p['body_part'];
            final physicianRaw = p['doctor_name'];
            final bodyPartStr = (bodyPartRaw is List) ? bodyPartRaw.join('\n') : (bodyPartRaw is String ? bodyPartRaw : '-');
            final physicianStr = (physicianRaw is List) ? physicianRaw.join('\n') : (physicianRaw is String ? physicianRaw : '-');

            return DataRow(
                onSelectChanged: (_) {
                  Navigator.pushNamed(context, '/profile/patient/${p['mrn']}');
                },
                cells: [
                  DataCell(Checkbox(
                    value: false,
                    onChanged: (val) {},
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                  )),
                  DataCell(Row(children: [
                    CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 12))),
                    const SizedBox(width: 8),
                    Text(p['name'], style: const TextStyle(color: Colors.white)),
                  ])),
                  DataCell(Text('${p['age']}', style: const TextStyle(color: Colors.white))),
                  DataCell(Text(p['mrn'], style: const TextStyle(color: Colors.white))),
                  DataCell(Text(
                    bodyPartStr,
                    style: const TextStyle(color: Colors.white),
                  )),
                  DataCell(Text(
                    physicianStr,
                    style: const TextStyle(color: Colors.white),
                  )),
                  DataCell(
                    Center(
                      child: Icon(
                        p['ai_ready'] == true ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: p['ai_ready'] == true ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                  DataCell(IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white), onPressed: () {})),
                ]);
          }).toList(),
        ),
      ),
    );
  }
}

// // 환자 목록 테이블
// class PatientTable extends StatefulWidget {
//   final List<Map<String, dynamic>> data;
//   const PatientTable({super.key, required this.data});

//   @override
//   State<PatientTable> createState() => _PatientTableState();
// }

// class _PatientTableState extends State<PatientTable> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.data.isEmpty) {
//       return const Center(
//         child: Text('No assigned patients.', style: TextStyle(color: Colors.white)),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: DataTable(
//         dataRowColor: WidgetStateProperty.all(Colors.transparent),
//         headingRowColor: WidgetStateProperty.all(Colors.transparent),
//         headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         columns: const [
//           DataColumn(label: Text(' ')), // 체크박스용
//           DataColumn(label: Row(children: [Text('Name'), Icon(Icons.arrow_downward, size: 16)])),
//           DataColumn(label: Row(children: [Text('Age'), Icon(Icons.arrow_downward, size: 16)])),
//           DataColumn(label: Row(children: [Text('MRN'), Icon(Icons.arrow_downward, size: 16)])),
//           DataColumn(label: Row(children: [Text('Body Part'), Icon(Icons.arrow_downward, size: 16)])),
//           DataColumn(label: Row(children: [Text('Physician'), Icon(Icons.arrow_downward, size: 16)])),
//           DataColumn(label: Text('AI Ready')),
//           DataColumn(label: Text(' ')), // 점 3개 메뉴용
//         ],
//         rows: widget.data.map((p) {
//           final initials = p['name'].toString().trim().split(RegExp(r'\s+')).take(2).map((s) => s[0].toUpperCase()).join();
//           final bodyPartRaw = p['body_part'];
//           final physicianRaw = p['doctor_name'];
//           final bodyPartStr = (bodyPartRaw is List) ? bodyPartRaw.join('\n') : (bodyPartRaw is String ? bodyPartRaw : '-');
//           final physicianStr = (physicianRaw is List) ? physicianRaw.join('\n') : (physicianRaw is String ? physicianRaw : '-');

//           return DataRow(
//               onSelectChanged: (_) {
//                 Navigator.pushNamed(context, '/profile/patient/${p['mrn']}');
//               },
//               cells: [
//                 DataCell(Checkbox(
//                   value: false,
//                   onChanged: (val) {},
//                   checkColor: Colors.white,
//                   activeColor: Colors.blue,
//                 )),
//                 DataCell(Row(children: [
//                   CircleAvatar(
//                       backgroundColor: Colors.blue,
//                       child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 12))),
//                   const SizedBox(width: 8),
//                   Text(p['name'], style: const TextStyle(color: Colors.white)),
//                 ])),
//                 DataCell(Text('${p['age']}', style: const TextStyle(color: Colors.white))),
//                 DataCell(Text(p['mrn'], style: const TextStyle(color: Colors.white))),
//                 DataCell(Text(
//                   bodyPartStr,
//                   style: const TextStyle(color: Colors.white),
//                 )),
//                 DataCell(Text(
//                   physicianStr,
//                   style: const TextStyle(color: Colors.white),
//                 )),
//                 DataCell(Text(p['ai_ready'].toString(), style: const TextStyle(color: Colors.white))),
//                 DataCell(IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white), onPressed: () {})),
//               ]);
//         }).toList(),
//       ),
//     );
//   }
// }

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
    final start = totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    final end = totalItems == 0 ? 0 : (currentPage * pageSize).clamp(1, totalItems);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          totalItems == 0 ? 'No patients to show.' : 'Showing $start-$end of $totalItems patient${totalItems == 1 ? '' : 's'}',
          style: TextStyle(color: Colors.grey[400]),
        ),
        Row(
          children: [
            TextButton(
                onPressed: currentPage > 1 ? () => onPageSelected(currentPage - 1) : null, child: const Text('< Previous')),
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
              onPressed: currentPage < totalPages ? () => onPageSelected(currentPage + 1) : null,
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
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF3A65E5) : Colors.transparent,
          foregroundColor: Colors.white,
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text),
      ),
    );
  }
}
