import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/widgets/navigation_sidebar.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  Widget build(BuildContext context) {
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
                          Text('156 patients',
                              style: TextStyle(color: Colors.grey[400])),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: () {},
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
                const Expanded(
                  child: PatientTable(),
                ),
                // 4. 페이지네이션
                const Pagination(),
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
  const PatientTable({super.key});

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
        rows: patientData
            .map((patient) => DataRow(
                  cells: [
                    DataCell(Checkbox(
                        value: false,
                        onChanged: (val) {},
                        checkColor: Colors.white,
                        activeColor: Colors.blue)),
                    DataCell(Row(children: [
                      CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                              patient['name'].substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12))),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(patient['name'],
                              style: const TextStyle(color: Colors.white)),
                          Text(patient['gender'],
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12)),
                        ],
                      ),
                    ])),
                    DataCell(Text(patient['age'].toString(),
                        style: const TextStyle(color: Colors.white))),
                    DataCell(Text(patient['mrn'],
                        style: const TextStyle(color: Colors.white))),
                    DataCell(Text(patient['part'],
                        style: const TextStyle(color: Colors.white))),
                    DataCell(Text(patient['physician'],
                        style: const TextStyle(color: Colors.white))),
                    DataCell(patient['ai_ready']
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.circle_outlined, color: Colors.grey[400])),
                    DataCell(IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.white),
                        onPressed: () {})),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

// 하단 페이지 번호들
class Pagination extends StatelessWidget {
  const Pagination({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Showing 1-8 of 156 patients',
            style: TextStyle(color: Colors.grey[400])),
        Row(
          children: [
            TextButton(onPressed: () {}, child: const Text('< Previous')),
            // 페이지 번호 버튼들
            _buildPageButton('1', isSelected: true),
            _buildPageButton('2'),
            _buildPageButton('3'),
            const Text('...', style: TextStyle(color: Colors.white)),
            _buildPageButton('20'),
            TextButton(onPressed: () {}, child: const Text('Next >')),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () {},
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
