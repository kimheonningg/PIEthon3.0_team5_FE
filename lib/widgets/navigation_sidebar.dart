// Navigation Sidebar 위젯
import 'dart:convert' as convert; 
import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/functions/user_info_manager.dart';
import 'package:piethon_team5_fe/screens/profile/doctor_profile_screen.dart';

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  // 현재 선택된 메뉴의 인덱스를 저장하는 변수
  // 0: Patients, 1: Schedule, ..., 4: Settings, 5: Help
  int _selectedIndex = 0;

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
      width: 256, //고정
      color: MainColors.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                Gaps.h4,
                Image.asset(
                  'assets/images/logo.png',
                  scale: 4,
                ),
              ],
            ),
          ),
          //구분선
          Container(
            height: 1,
            color: const Color(0xFF374151),
          ),
          // Navigation 섹션
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Navigation'),
                  Gaps.v10,
                  NavItem(
                    icon: Icons.people_outline,
                    title: 'Patients',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  NavItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Schedule',
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  NavItem(
                    icon: Icons.bar_chart_outlined,
                    title: 'Reports',
                    isSelected: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  NavItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'AI Tools',
                    isSelected: _selectedIndex == 3,
                    onTap: () => setState(() => _selectedIndex = 3),
                  ),

                  Gaps.v30,

                  // Workspace 섹션
                  const SectionTitle(title: 'Workspace'),
                  const SizedBox(height: 10),
                  NavItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    isSelected: _selectedIndex == 4,
                    onTap: () => setState(() => _selectedIndex = 4),
                  ),
                  NavItem(
                    icon: Icons.help_outline,
                    title: 'Help',
                    isSelected: _selectedIndex == 5,
                    onTap: () => setState(() => _selectedIndex = 5),
                  ),
                ],
              ),
            ),
          ),
          //구분선
          Container(
            height: 1,
            color: const Color(0xFF374151),
          ),
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
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName,
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

// 네비게이션 메뉴 아이템 위젯
class NavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
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
        onHover: (hovering) {
          setState(() {
            _isHovering = hovering;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            // isSelected가 true이면 파란색, isHovering이 true이면 연한 회색, 둘 다 아니면 투명
            color: widget.isSelected
                ? MainColors.sidebarItemSelectedBackground
                : _isHovering
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected
                    ? MainColors.sidebarItemSelectedText
                    : MainColors.sidebarItemText,
                size: 16,
              ),
              Gaps.h12,
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.isSelected
                      ? MainColors.sidebarItemSelectedText
                      : MainColors.sidebarItemText,
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

// 섹션 제목 위젯
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: MainColors.sidebarNameText,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
