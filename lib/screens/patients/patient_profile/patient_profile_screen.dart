// "/profile/patient" 경로
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; 
import 'package:piethon_team5_fe/screens/patients/patient_profile/graphview.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/mainview.dart';
import 'package:piethon_team5_fe/screens/patients/patient_profile/patient_profile_sidebar.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/functions/patient_info_manager.dart';
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';

import '../../../widgets/gaps.dart';

class PatientProfileScreen extends StatefulWidget {
  final String mrn;

  const PatientProfileScreen({super.key, required this.mrn});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreen();
}

class _PatientProfileScreen extends State<PatientProfileScreen> {
  bool _isMainview = true; //MainView를 보여주는 중인지, GraphView를 보여주는 중인지
  bool _isAIAssistantShowing = true; //AI Assistant 창 표시 여부
  final TextEditingController _chatController = TextEditingController();
  List<Map<String, dynamic>> _chatMessages = [];
  String? _conversationId;

  Map<String, dynamic>? patientInfo;

  @override
  void initState() {
    super.initState();
    _loadPatientInfo();
  }

  Future<void> _loadPatientInfo() async {
    final info = await PatientInfoManager.loadByMrn(widget.mrn);
    setState(() {
      patientInfo = info;
    });
  }

  List<String> _extractReferences(String text) {
    final internal = RegExp(r'\b[a-zA-Z]+_[a-zA-Z0-9]+\b');
    final external = RegExp(r'\[([a-zA-Z0-9]{6,12})\]');

    final internalMatches = internal.allMatches(text).map((m) => m.group(0)!);
    final externalMatches = external.allMatches(text).map((m) => "[${m.group(1)!}]");

    return [...internalMatches, ...externalMatches].toSet().toList(); // 중복 제거
  }

  Future<void> _sendMessage() async {
    final query = _chatController.text.trim();
    if (query.isEmpty || patientInfo == null) return;

    setState(() {
      _chatMessages.add({"isUser": true, "text": query});
      _chatController.clear();
    });

    final uri = Uri.parse('$BASE_URL/agent/chat');
    final body = jsonEncode({
      "query": query,
      "patient_mrn": patientInfo!['mrn'],
      if (_conversationId != null) "conversation_id": _conversationId,
    });

    final token = await TokenManager.getAccessToken();
    final response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final text = json["response"]["text"] ?? "";
      final references = _extractReferences(text);

      setState(() {
        _conversationId = json["conversation_id"];
        _chatMessages.add({
          "isUser": false,
          "text": text,
          "references": references,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const PatientProfileSidebar(),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // main view / graph view 선택
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isMainview = true;
                              });
                            },
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text('Main View'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: _isMainview ? MainColors.button2 : Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isMainview = false;
                              });
                            },
                            icon: const Icon(
                              Icons.bubble_chart_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text('Graph View'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: !_isMainview ? MainColors.button2 : Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),

                          const Spacer(),
                          // 사용자 프로필 등 추가 가능
                        ],
                      ),
                    ),
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
                          Gaps.h8,
                          const Text('AI System: Online', style: TextStyle(color: Color(0xFF4B5563))),
                          Gaps.h12,
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isAIAssistantShowing = !_isAIAssistantShowing;
                              });
                            },
                            child: Image.asset(
                              'assets/images/ai.png',
                              scale: 4,
                              color: _isAIAssistantShowing ? MainColors.selectedTab : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: const Color(0x88374151),
              ),
              Expanded(
                  child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: _isMainview
                                ? (patientInfo != null
                                    ? Mainview(key: const PageStorageKey('MainView'), patientInfo: patientInfo!)
                                    : const Center(child: CircularProgressIndicator()))
                                : const GraphView(),
                          ),
                          //AI Assistant 창

                          AnimatedContainer(
                            key: const PageStorageKey('AI Assistant'),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            width: _isAIAssistantShowing ? 320 : 0,
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
                                            IconButton(
                                                icon: const Icon(Icons.history),
                                                color: MainColors.sidebarItemText,
                                                onPressed: () {}),
                                            IconButton(
                                                icon: const Icon(Icons.close),
                                                color: MainColors.sidebarItemText,
                                                onPressed: () {
                                                  setState(() {
                                                    _isAIAssistantShowing = false;
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
                                            children: _chatMessages.map((msg) {
                                              return _buildChatMessage(
                                                isUser: msg["isUser"],
                                                text: msg["text"],
                                                references: msg["references"]?.cast<String>(),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                  ),
                                  // 채팅 입력 필드
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child:TextField(
                                      controller: _chatController,
                                      decoration: InputDecoration(
                                        hintText: 'Ask a question about this patient...',
                                        hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 14),
                                        filled: true,
                                        fillColor: MainColors.textfield,
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.send),
                                          color: Colors.white,
                                          onPressed: _sendMessage,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildChatMessage({
    required String text, 
    required bool isUser,
    List<String>? references,
  }) {

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? MainColors.button2 : MainColors.sidebarItemSelectedText,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(color: Colors.white)),
            if (!isUser && references != null && references.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: references.map((ref) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ref,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
            )
          ]
        ],
      ),
    ),
  );
}
}