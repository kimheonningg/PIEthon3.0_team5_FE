import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  final int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Medical History', 'Imaging', 'Treatment Plans', 'Clinical Notes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Row(
          // 메인 콘텐츠(SingleChildScrollView)와 AI 어시스턴트 채팅창
          children: [
            Expanded(
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
                            Gaps.h4,
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
                                  Text('42 years (DOB: 04/12/1983)',
                                      style: TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
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
                                  Text('42 years (DOB: 04/12/1983)',
                                      style: TextStyle(color: MainColors.sidebarNameText, fontSize: 14)),
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
                            children: _tabs.map((String name) {
                              return Center(
                                child: Text(
                                  name,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              );
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
            // AI 어시스턴트 채팅창
            const AIAssistantBox(),
          ],
        ),
      ),
    );
  }
}

class AIAssistantBox extends StatefulWidget {
  const AIAssistantBox({super.key});

  @override
  State<AIAssistantBox> createState() => _AIAssistantBoxState();
}

class _AIAssistantBoxState extends State<AIAssistantBox> {
  bool _isShowing = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      width: _isShowing ? 320 : 0,
      height: double.infinity,
      decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0x88374151), width: 1))),
      child: ClipRRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text('AI Assistant',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  ClipRRect(
                    child: Row(children: [
                      IconButton(icon: const Icon(Icons.history), color: MainColors.sidebarItemText, onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.close),
                          color: MainColors.sidebarItemText,
                          onPressed: () {
                            setState(() {
                              _isShowing = false;
                            });
                          }),
                      IconButton(icon: const Icon(Icons.settings_outlined), color: MainColors.sidebarItemText, onPressed: () {}),
                    ]),
                  ),
                ],
              ),
            ),
            // 구분선
            Container(
              height: 1,
              color: const Color(0x88374151),
            ),
            // 메인 채팅
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildChatMessage(
                      isUser: false,
                      text:
                          "Hello! I've analyzed Emily Browning's medical records. The recent MRI shows a pulmonary nodule that has grown since the previous CT scan. Would you like me to provide more details about this finding?",
                    ),
                    _buildChatMessage(
                      isUser: true,
                      text: "Yes, please provide more details about the nodule and any recommendations.",
                    ),
                  ],
                ),
              ),
            )),
            // 채팅 입력 필드
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ask a question about this patient...',
                  hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 14),
                  filled: true,
                  fillColor: MainColors.textfield,
                  suffixIcon: IconButton(icon: const Icon(Icons.send), color: Colors.white, onPressed: () {}),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildChatMessage({required String text, required bool isUser}) {
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? MainColors.button2 : MainColors.sidebarItemSelectedText,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );
}

////////////////////////////////////////

// 2. 메인 콘텐츠 패널
class PatientContentPanel extends StatefulWidget {
  const PatientContentPanel({super.key});

  @override
  State<PatientContentPanel> createState() => _PatientContentPanelState();
}

class _PatientContentPanelState extends State<PatientContentPanel> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Medical History', 'Imaging', 'Treatment Plans', 'Clinical Notes'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 탭 바
          Row(
            children: List.generate(_tabs.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = index),
                  child: Column(
                    children: [
                      Text(
                        _tabs[index],
                        style: TextStyle(
                          color: _selectedTabIndex == index ? MainColors.sidebarItemSelectedText : MainColors.button2,
                          fontWeight: _selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedTabIndex == index)
                        Container(
                          height: 3,
                          width: 40,
                          color: MainColors.sidebarItemSelectedText,
                        )
                    ],
                  ),
                ),
              );
            }),
          ),
          const Divider(color: Colors.grey, height: 1),
          const SizedBox(height: 24),
          // 탭 콘텐츠
          _buildTabContent(),
        ],
      ),
    );
  }

  // ... _buildPatientHeader, _buildTabContent 등 상세 구현은 아래에 계속 ...
  // PatientContentPanel 내부에 추가
  Widget _buildTabContent() {
    // 현재는 Overview 탭만 구현
    if (_selectedTabIndex == 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 컬럼
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildInfoCard(
                  title: 'Current Treatment Plan',
                  child: const Column(
                      // ... 약, 시술, 후속 조치 내용 ...
                      ),
                ),
                const SizedBox(height: 24),
                _buildInfoCard(
                  title: 'Recent Examinations',
                  child: const Column(
                      // ... 최근 검사 내용 ...
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // 오른쪽 컬럼
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildImagingCard(
                  title: 'Imaging with AI Analysis : T1',
                  imageUrl: 'https://storage.googleapis.com/gemini-prod/images/42534571-f925-4720-911e-089c8a99d45e', // 예시 이미지
                ),
              ],
            ),
          ),
        ],
      );
    }
    // 다른 탭을 위한 빈 컨테이너
    return Container(child: Text(_tabs[_selectedTabIndex], style: const TextStyle(color: Colors.white)));
  }

// 재사용 가능한 정보 카드
  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: MainColors.button2, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

// 이미징 카드
  Widget _buildImagingCard({required String title, required String imageUrl}) {
    return _buildInfoCard(
      title: title,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          // ... AI 분석 결과, 이전 연구와 비교 등 추가 구현 ...
          const Text('AI Analysis Results: Pulmonary Nodule...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
