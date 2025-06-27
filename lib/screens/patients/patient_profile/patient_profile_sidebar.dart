// Navigation Sidebar 위젯
import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class PatientProfileSidebar extends StatefulWidget {
  const PatientProfileSidebar({super.key});

  @override
  State<PatientProfileSidebar> createState() => _PatientProfileSidebar();
}

class _PatientProfileSidebar extends State<PatientProfileSidebar> {
  // 현재 선택된 메뉴의 인덱스를 저장하는 변수
  // 0: Patients, 1: Schedule, ..., 4: Settings, 5: Help
  int _selectedIndex = 0;

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
                InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Gaps.h4,
                Image.asset(
                  'assets/images/logo.png',
                  scale: 4,
                ),
              ],
            ),
          ),
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
                    Icon(
                      Icons.search,
                      size: 18,
                    ),
                    Gaps.h2,
                    Icon(Icons.filter_list, size: 18)
                  ],
                )
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DateSection(title: '2025-06-25'),
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
                    const DateSection(title: '2025-06-14'),
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
          ),
          //구분선
          Container(
            height: 1,
            color: const Color(0xFF374151),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "멋진 로그인 정보",
              style: TextStyle(fontSize: 20),
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
                color: widget.isSelected ? MainColors.sidebarItemSelectedText : MainColors.sidebarItemText,
                size: 16,
              ),
              Gaps.h12,
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.isSelected ? MainColors.sidebarItemSelectedText : MainColors.sidebarItemText,
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
class DateSection extends StatelessWidget {
  final String title;
  const DateSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.keyboard_arrow_down,
          color: MainColors.sidebarNameText,
        ),
        Gaps.h4,
        Text(
          title,
          style: const TextStyle(
            color: MainColors.sidebarNameText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
