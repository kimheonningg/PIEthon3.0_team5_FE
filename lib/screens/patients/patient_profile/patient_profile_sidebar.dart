import 'dart:convert' as convert; 
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:piethon_team5_fe/provider/mainview_tab_provider.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:provider/provider.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/functions/user_info_manager.dart';

class PatientProfileSidebar extends StatefulWidget {
  const PatientProfileSidebar({super.key});

  @override
  State<PatientProfileSidebar> createState() => _PatientProfileSidebar();
}

class _PatientProfileSidebar extends State<PatientProfileSidebar> {
  String _displayName = 'name';
  String _displayRole = 'role';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final info = await UserInfoManager.load();
      if (info != null) {
        final first = info['first_name'] ?? '';
        final last  = info['last_name']  ?? '';
        final role  = info['position']  ?? '';

        setState(() {
          _displayName = [last, first].where((s) => s.isNotEmpty).join(' ');
          _displayRole = role;
        });

        return;
      }
      // 백업용
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) return;

      final parts = token.split('.');
      if (parts.length != 3) return;
      final payload = convert.utf8.decode(
        convert.base64Url.decode(_padBase64(parts[1])),
      );
      final data   = convert.jsonDecode(payload) as Map<String, dynamic>;

      final first = data['first_name'] ?? '';
      final last  = data['last_name']  ?? '';
      final role  = data['position']  ??'';

      setState(() {
        _displayName = [last, first].where((s) => s.isNotEmpty).join(' ');
        _displayRole = role;
      });
    } catch (e) {
      print('프로필 로드 실패: $e');
    }
  }

  String _padBase64(String input) {
    final mod = input.length % 4;
    if (mod == 0) return input;
    return input + '=' * (4 - mod);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      color: MainColors.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 로고 & 뒤로가기
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
                ),
                Gaps.h4,
                Image.asset(
                  'assets/images/logo.png',
                  scale: 4,
                ),
              ],
            ),
          ),
          // 섹션 제목 & 검색/필터 아이콘
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patient History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.search, size: 18),
                    Gaps.h2,
                    Icon(Icons.filter_list, size: 18),
                  ],
                )
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFF374151)),
          // 히스토리 목록
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientHistoryItem(title: '2025-06-25'),
                    Gaps.v8,
                    PatientHistoryItem(title: '2025-06-14'),
                  ],
                ),
              ),
            ),
          ),
          const Divider(color: MainColors.dividerLine, height: 1),
          // 사용자 정보 & 프로필로 이동
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile/doctor');
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: MainColors.userProfile,
                    child: const Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr ${_displayName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_displayRole.isNotEmpty)
                        Text(
                          _displayRole,
                          style: const TextStyle(
                            color: MainColors.sidebarNameText,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 날짜별 접히는 섹션
class PatientHistoryItem extends StatefulWidget {
  final String title;
  const PatientHistoryItem({super.key, required this.title});

  @override
  State<PatientHistoryItem> createState() => _PatientHistoryItemState();
}

class _PatientHistoryItemState extends State<PatientHistoryItem> {
  bool _isFold = true;

  @override
  Widget build(BuildContext context) {
    final mainviewTabProvider = context.read<MainviewTabProvider>();
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isFold = !_isFold),
          child: Row(
            children: [
              Icon(
                _isFold ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_down,
                color: MainColors.sidebarNameText,
              ),
              Gaps.h4,
              Text(
                widget.title,
                style: const TextStyle(
                  color: MainColors.sidebarNameText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!_isFold)
          Column(
            children: [
              NavItem(
                icon: Icons.people_outline,
                title: 'Clinical Notes',
                onTap: () => mainviewTabProvider.changeTab('Clinical Notes'),
              ),
              NavItem(
                icon: Icons.calendar_today_outlined,
                title: 'Medications',
                onTap: () => mainviewTabProvider.changeTab('Treatment Plans'),
              ),
              NavItem(
                icon: Icons.bar_chart_outlined,
                title: 'Chest MRI',
                onTap: () => mainviewTabProvider.changeTab('Imaging'),
              ),
              NavItem(
                icon: Icons.camera_alt_outlined,
                title: 'Chest CT',
                onTap: () => mainviewTabProvider.changeTab('Imaging'),
              ),
            ],
          ),
      ],
    );
  }
}

// 네비게이션 항목
class NavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: widget.onTap,
        onHover: kIsWeb
            ? (hovering) => setState(() => _isHovering = hovering)
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon, color: MainColors.sidebarItemText, size: 16),
              Gaps.h12,
              Text(
                widget.title,
                style: const TextStyle(
                  color: MainColors.sidebarItemText,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
