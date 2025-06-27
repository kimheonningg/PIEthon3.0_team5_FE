import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
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
                                  style: TextStyle(
                                      color: MainColors.sidebarItemText,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
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
                                style: TextStyle(
                                    color: MainColors.button2, fontSize: 16),
                              ),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
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
                                      style: TextStyle(
                                          color: MainColors.sidebarNameText,
                                          fontSize: 14)),
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
                                      style: TextStyle(
                                          color: MainColors.sidebarNameText,
                                          fontSize: 14)),
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
                                  Text('MRN: 78942651',
                                      style: TextStyle(
                                          color: MainColors.sidebarNameText,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [],
                        ),
                      ),
                    ),
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
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Color(0x88374151), width: 1))),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  ClipRRect(
                    child: Row(children: [
                      IconButton(
                          icon: const Icon(Icons.history),
                          color: MainColors.sidebarItemText,
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.close),
                          color: MainColors.sidebarItemText,
                          onPressed: () {
                            setState(() {
                              _isShowing = false;
                            });
                          }),
                      IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          color: MainColors.sidebarItemText,
                          onPressed: () {}),
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
                      text:
                          "Yes, please provide more details about the nodule and any recommendations.",
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
                  hintStyle:
                      const TextStyle(color: MainColors.hinttext, fontSize: 14),
                  filled: true,
                  fillColor: MainColors.textfield,
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () {}),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
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
